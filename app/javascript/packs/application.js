import "bootstrap";

import 'mapbox-gl/dist/mapbox-gl.css'; // <-- you need to uncomment the stylesheet_pack_tag in the layout!
import { initMapbox } from '../plugins/init_mapbox';

import { setHourlyRate } from '../plugins/set_hourly_rate';

initMapbox();
setHourlyRate();
$('[data-toggle="tooltip"]').tooltip();
