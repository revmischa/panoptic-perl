Panoptic is a system for capturing and viewing live video from video cameras.

## Installing

### Dependencies
* Clone rapid and install it (it's not in CPAN yet)
* Make sure you have `libjpeg-dev` and `libpng-dev`
* Install deps: `cpanm -v -n --installdeps .`

### Config
* `cp sample/panoptic_local.yml ./`
* Edit panoptic_local.yml, set up DB config

### Database
* Deploy schema with `script/panoptic_deploy_schema.pl`
* Populate DB with `script/panoptic_populate.pl`

### Run test server
* `script/panoptic_server.pl -r`

