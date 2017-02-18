import Dropdown, { DropdownTrigger, DropdownContent } from 'react-simple-dropdown';

const DropdownMenu = ({ icon, items, size, direction }) => {
  const directionClass = (direction == "left") ? "dropdown__left" : "dropdown__right";

  return (
    <Dropdown>
      <DropdownTrigger className='icon-button' style={{ fontSize: `${size}px`, width: `${size}px`, lineHeight: `${size}px` }}>
        <i className={`fa fa-fw fa-${icon}`} style={{ verticalAlign: 'middle' }} />
      </DropdownTrigger>

      <DropdownContent className={directionClass} style={{ lineHeight: '18px', textAlign: 'left' }}>
        <ul>
          {items.map(({ text, action, href = '#' }, i) => <li key={i}><a href={href} target='_blank' rel='noopener' onClick={e => {
            if (typeof action === 'function') {
              e.preventDefault();
              action();
            }
          }}>{text}</a></li>)}
        </ul>
      </DropdownContent>
    </Dropdown>
  );
};

DropdownMenu.propTypes = {
  icon: React.PropTypes.string.isRequired,
  items: React.PropTypes.array.isRequired,
  size: React.PropTypes.number.isRequired
};

export default DropdownMenu;
