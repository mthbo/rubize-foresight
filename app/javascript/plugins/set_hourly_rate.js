import $ from 'jquery';
import barrating from 'jquery-bar-rating';

const setHourlyRate = () => {
  $('.barrating').barrating({
    theme: 'bars-horizontal',
    reverse: true
  });
};

export { setHourlyRate };
