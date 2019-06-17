import datepicker from 'bootstrap-datepicker';

const initDatepicker = () => {
  $.fn.datepicker.dates['en']['format'] = 'yyyy-mm-dd'
  $('.datepicker').datepicker({
    todayHighlight: true,
    autoclose: true
  })
};

export { initDatepicker };
