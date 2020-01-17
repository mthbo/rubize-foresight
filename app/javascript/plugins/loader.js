const toggleLoader = () => {
  let forceClose = false;
  const $customLoader = $("#custom-loader");
  $customLoader.on('shown.bs.modal', function() {
    if (forceClose) {
      $customLoader.modal('hide');
    }
  });
  $customLoader.on('hidden.bs.modal', function() {
    forceClose = false;
  });
  document.body.addEventListener('ajax:send', function(event) {
    $customLoader.modal('show');
  });
  document.body.addEventListener('ajax:complete', function(event) {
    forceClose = true;
    $customLoader.modal('hide');
  });
  document.body.addEventListener('ajax:stopped', function(event) {
    forceClose = true;
    $customLoader.modal('hide');
  });
};

export { toggleLoader };
