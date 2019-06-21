import barrating from 'jquery-bar-rating';

const initBarrating = () => {
  window.$ = $;
  $('.barrating').barrating({
    theme: 'bars-horizontal',
    reverse: true
  });
};

export { initBarrating };
