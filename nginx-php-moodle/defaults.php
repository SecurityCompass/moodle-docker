<?php

// Enable Moove theme
$defaults['moodle']['theme'] = 'moove';

// Override default password policy to remove non-alphanumeric character requirement
$defaults['moodle']['minpasswordnonalphanum'] = 0;

// Skip Moodle registration
$defaults['moodle']['registrationpending'] = 0;
