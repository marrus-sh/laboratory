import ImmutablePropTypes from 'react-immutable-proptypes';
import PureRenderMixin from 'react-addons-pure-render-mixin';
import IconButton from './icon_button';
import { defineMessages, injectIntl, FormattedMessage } from 'react-intl';

const messages = defineMessages({
  toggle_visible: { id: 'media_gallery.toggle_visible', defaultMessage: 'Toggle visibility' }
});

const outerStyle = {
  marginTop: '8px',
  overflow: 'hidden',
  width: '100%',
  boxSizing: 'border-box',
  position: 'relative'
};

const spoilerStyle = {
  textAlign: 'center',
  height: '100%',
  cursor: 'pointer',
  display: 'flex',
  alignItems: 'center',
  justifyContent: 'center',
  flexDirection: 'column'
};

const spoilerSpanStyle = {
  display: 'block',
  fontSize: '14px',
};

const spoilerSubSpanStyle = {
  display: 'block',
  fontSize: '11px',
  fontWeight: '500'
};

const spoilerButtonStyle = {
  position: 'absolute',
  top: '6px',
  left: '8px',
  zIndex: '100'
};

const MediaGallery = React.createClass({

  getInitialState () {
    return {
      visible: !this.props.sensitive
    };
  },

  propTypes: {
    sensitive: React.PropTypes.bool,
    media: ImmutablePropTypes.list.isRequired,
    height: React.PropTypes.number.isRequired,
    onOpenMedia: React.PropTypes.func.isRequired,
    intl: React.PropTypes.object.isRequired
  },

  mixins: [PureRenderMixin],

  handleClick (index, e) {
    if (e.button === 0) {
      e.preventDefault();
      this.props.onOpenMedia(this.props.media, index);
    }

    e.stopPropagation();
  },

  handleOpen () {
    this.setState({ visible: !this.state.visible });
  },

  render () {
    const { media, intl, sensitive } = this.props;

    let children;

    if (!this.state.visible) {
      if (sensitive) {
        children = (
          <div style={spoilerStyle} className='media-spoiler' onClick={this.handleOpen}>
            <span style={spoilerSpanStyle}><FormattedMessage id='status.sensitive_warning' defaultMessage='Sensitive content' /></span>
            <span style={spoilerSubSpanStyle}><FormattedMessage id='status.sensitive_toggle' defaultMessage='Click to view' /></span>
          </div>
        );
      } else {
        children = (
          <div style={spoilerStyle} className='media-spoiler' onClick={this.handleOpen}>
            <span style={spoilerSpanStyle}><FormattedMessage id='status.media_hidden' defaultMessage='Media hidden' /></span>
            <span style={spoilerSubSpanStyle}><FormattedMessage id='status.sensitive_toggle' defaultMessage='Click to view' /></span>
          </div>
        );
      }
    } else {
      const size = media.take(4).size;

      children = media.take(4).map((attachment, i) => {
        let width  = 50;
        let height = 100;
        let top    = 'auto';
        let left   = 'auto';
        let bottom = 'auto';
        let right  = 'auto';

        if (size === 1) {
          width = 100;
        }

        if (size === 4 || (size === 3 && i > 0)) {
          height = 50;
        }

        if (size === 2) {
          if (i === 0) {
            right = '2px';
          } else {
            left = '2px';
          }
        } else if (size === 3) {
          if (i === 0) {
            right = '2px';
          } else if (i > 0) {
            left = '2px';
          }

          if (i === 1) {
            bottom = '2px';
          } else if (i > 1) {
            top = '2px';
          }
        } else if (size === 4) {
          if (i === 0 || i === 2) {
            right = '2px';
          }

          if (i === 1 || i === 3) {
            left = '2px';
          }

          if (i < 2) {
            bottom = '2px';
          } else {
            top = '2px';
          }
        }

        return (
          <div key={attachment.get('id')} style={{ boxSizing: 'border-box', position: 'relative', left: left, top: top, right: right, bottom: bottom, float: 'left', border: 'none', display: 'block', width: `${width}%`, height: `${height}%` }}>
            <a href={attachment.get('remote_url') ? attachment.get('remote_url') : attachment.get('url')} onClick={this.handleClick.bind(this, i)} target='_blank' style={{ display: 'block', width: '100%', height: '100%', background: `url(${attachment.get('preview_url')}) no-repeat center`, textDecoration: 'none', backgroundSize: 'cover', cursor: 'zoom-in' }} />
          </div>
        );
      });
    }

    return (
      <div style={{ ...outerStyle, height: `${this.props.height}px` }}>
        <div style={spoilerButtonStyle} >
          <IconButton title={intl.formatMessage(messages.toggle_visible)} icon={this.state.visible ? 'eye' : 'eye-slash'} onClick={this.handleOpen} />
        </div>
        {children}
      </div>
    );
  }

});

export default injectIntl(MediaGallery);
