import "bootstrap";
import "bootstrap-datepicker";

import 'mapbox-gl/dist/mapbox-gl.css'; // <-- you need to uncomment the stylesheet_pack_tag in the layout!
import { initMapbox } from '../plugins/init_mapbox';
import { setHourlyRate } from '../plugins/set_hourly_rate';
import { setDatepicker } from '../plugins/datepicker';

initMapbox();
setHourlyRate();
setDatepicker();
$('[data-toggle="tooltip"]').tooltip();
