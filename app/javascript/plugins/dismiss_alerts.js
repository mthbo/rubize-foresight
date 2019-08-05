const dismissAlert = (alert) => {
  window.setTimeout(
    function() {
      alert.alert('close');
    }, 3000);
};

const dismissAlerts = () => {
  dismissAlert($('#alert_notice'));
  dismissAlert($('#alert_warning'));
};

export { dismissAlerts };
