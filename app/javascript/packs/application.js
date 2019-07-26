import "bootstrap";

import { initTooltip } from '../plugins/init_bootstrap_tooltip';
import { initBarrating } from '../plugins/load_barrating';
import { initDatepicker } from '../plugins/init_datepicker';
import { updateRefreshButton } from '../plugins/refresh_button';
import { dismissAlerts } from '../plugins/dismiss_alerts';
import { toggleInverter } from '../plugins/toggle_inverter';
import { toggleFrequency } from '../plugins/toggle_frequency';

initTooltip();
initBarrating();
initDatepicker();
updateRefreshButton();
dismissAlerts();
toggleInverter();
toggleFrequency();

