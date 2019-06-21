import "bootstrap";

import 'mapbox-gl/dist/mapbox-gl.css'; // <-- you need to uncomment the stylesheet_pack_tag in the layout!
import { initMapbox } from '../plugins/init_mapbox';
import { initTooltip } from '../plugins/init_bootstrap_tooltip';
import { initBarrating } from '../plugins/load_barrating';
import { initDatepicker } from '../plugins/init_datepicker';
import { updateRefreshButton } from '../plugins/refresh_button';

initMapbox();
initTooltip();
initBarrating();
initDatepicker();
updateRefreshButton();

