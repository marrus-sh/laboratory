import AutosuggestAccountContainer from '../features/compose/containers/autosuggest_account_container';
import ImmutablePropTypes from 'react-immutable-proptypes';

const textAtCursorMatchesToken = (str, caretPosition) => {
  let word;

  let left  = str.slice(0, caretPosition).search(/\S+$/);
  let right = str.slice(caretPosition).search(/\s/);

  if (right < 0) {
    word = str.slice(left);
  } else {
    word = str.slice(left, right + caretPosition);
  }

  if (!word || word.trim().length < 2 || word[0] !== '@') {
    return [null, null];
  }

  word = word.trim().toLowerCase().slice(1);

  if (word.length > 0) {
    return [left + 1, word];
  } else {
    return [null, null];
  }
};

const AutosuggestTextarea = React.createClass({

  propTypes: {
    value: React.PropTypes.string,
    suggestions: ImmutablePropTypes.list,
    disabled: React.PropTypes.bool,
    fileDropDate: React.PropTypes.instanceOf(Date),
    placeholder: React.PropTypes.string,
    onSuggestionSelected: React.PropTypes.func.isRequired,
    onSuggestionsClearRequested: React.PropTypes.func.isRequired,
    onSuggestionsFetchRequested: React.PropTypes.func.isRequired,
    onChange: React.PropTypes.func.isRequired,
    onKeyUp: React.PropTypes.func,
    onKeyDown: React.PropTypes.func
  },

  getInitialState () {
    return {
      isFileDragging: false,
      fileDraggingDate: undefined,
      suggestionsHidden: false,
      selectedSuggestion: 0,
      lastToken: null,
      tokenStart: 0
    };
  },

  onChange (e) {
    const [ tokenStart, token ] = textAtCursorMatchesToken(e.target.value, e.target.selectionStart);

    if (token !== null && this.state.lastToken !== token) {
      this.setState({ lastToken: token, selectedSuggestion: 0, tokenStart });
      this.props.onSuggestionsFetchRequested(token);
    } else if (token === null) {
      this.setState({ lastToken: null });
      this.props.onSuggestionsClearRequested();
    }

    this.props.onChange(e);
  },

  onKeyDown (e) {
    const { suggestions, disabled } = this.props;
    const { selectedSuggestion, suggestionsHidden } = this.state;

    if (disabled) {
      e.preventDefault();
      return;
    }

    switch(e.key) {
    case 'Escape':
      if (!suggestionsHidden) {
        e.preventDefault();
        this.setState({ suggestionsHidden: true });
      }

      break;
    case 'ArrowDown':
      if (suggestions.size > 0 && !suggestionsHidden) {
        e.preventDefault();
        this.setState({ selectedSuggestion: Math.min(selectedSuggestion + 1, suggestions.size - 1) });
      }

      break;
    case 'ArrowUp':
      if (suggestions.size > 0 && !suggestionsHidden) {
        e.preventDefault();
        this.setState({ selectedSuggestion: Math.max(selectedSuggestion - 1, 0) });
      }

      break;
    case 'Enter':
    case 'Tab':
      // Select suggestion
      if (this.state.lastToken !== null && suggestions.size > 0 && !suggestionsHidden) {
        e.preventDefault();
        e.stopPropagation();
        this.props.onSuggestionSelected(this.state.tokenStart, this.state.lastToken, suggestions.get(selectedSuggestion));
      }

      break;
    }

    if (e.defaultPrevented || !this.props.onKeyDown) {
      return;
    }

    this.props.onKeyDown(e);
  },

  onBlur () {
    // If we hide the suggestions immediately, then this will prevent the
    // onClick for the suggestions themselves from firing.
    // Setting a short window for that to take place before hiding the
    // suggestions ensures that can't happen.
    setTimeout(() => {
      this.setState({ suggestionsHidden: true });
    }, 100);
  },

  onSuggestionClick (suggestion, e) {
    e.preventDefault();
    this.props.onSuggestionSelected(this.state.tokenStart, this.state.lastToken, suggestion);
    this.textarea.focus();
  },

  componentWillReceiveProps (nextProps) {
    if (nextProps.suggestions !== this.props.suggestions && nextProps.suggestions.size > 0 && this.state.suggestionsHidden) {
      this.setState({ suggestionsHidden: false });
    }

    const fileDropDate = nextProps.fileDropDate;
    const { isFileDragging, fileDraggingDate } = this.state;

    /*
     * We can't detect drop events, because they might not be on the textarea (the app allows dropping anywhere in the
     * window). Instead, on-drop, we notify this textarea to stop its hover effect by passing in a prop with the
     * drop-date.
     */
    if (isFileDragging && fileDraggingDate && fileDropDate // if dragging when props updated, and dates aren't undefined
      && fileDropDate > fileDraggingDate) { // and if the drop date is now greater than when we started dragging
      // then we should stop dragging
      this.setState({
        isFileDragging: false
      });
    }
  },

  setTextarea (c) {
    this.textarea = c;
  },

  onDragEnter () {
    this.setState({
      isFileDragging: true,
      fileDraggingDate: new Date()
    })
  },

  onDragExit () {
    this.setState({
      isFileDragging: false
    })
  },

  render () {
    const { value, suggestions, fileDropDate, disabled, placeholder, onKeyUp } = this.props;
    const { isFileDragging, suggestionsHidden, selectedSuggestion } = this.state;
    const className = isFileDragging ? 'autosuggest-textarea__textarea file-drop' : 'autosuggest-textarea__textarea';

    return (
      <div className='autosuggest-textarea'>
        <textarea
          ref={this.setTextarea}
          className={className}
          disabled={disabled}
          placeholder={placeholder}
          autoFocus={true}
          value={value}
          onChange={this.onChange}
          onKeyDown={this.onKeyDown}
          onKeyUp={onKeyUp}
          onBlur={this.onBlur}
          onDragEnter={this.onDragEnter}
          onDragExit={this.onDragExit}
        />

        <div style={{ display: (suggestions.size > 0 && !suggestionsHidden) ? 'block' : 'none' }} className='autosuggest-textarea__suggestions'>
          {suggestions.map((suggestion, i) => (
            <div key={suggestion} className={`autosuggest-textarea__suggestions__item ${i === selectedSuggestion ? 'selected' : ''}`} onClick={this.onSuggestionClick.bind(this, suggestion)}>
              <AutosuggestAccountContainer id={suggestion} />
            </div>
          ))}
        </div>
      </div>
    );
  }

});

export default AutosuggestTextarea;
