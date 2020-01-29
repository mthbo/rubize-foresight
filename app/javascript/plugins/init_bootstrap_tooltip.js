const initTooltip = () => {
  $('[data-toggle="tooltip"]').tooltip();
};

const initPopover = () => {
  $('[data-toggle="popover"]').popover()
};

export { initTooltip };
export { initPopover };
