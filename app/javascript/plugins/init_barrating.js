import barrating from 'jquery-bar-rating';

const initBarrating = () => {
  $('.barrating').barrating({
    theme: 'bars-horizontal',
    reverse: true
  });
};

export { initBarrating };
