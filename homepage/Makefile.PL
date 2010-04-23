#!/usr/bin/env perl

use inc::Module::Install;
use Module::Install::Catalyst;

name 'Int80';
all_from 'lib/Int80.pm';

requires 'Catalyst::Runtime' => '5.80022';
requires 'Catalyst::Plugin::ConfigLoader';
requires 'Catalyst::Plugin::Static::Simple';
requires 'Catalyst::Action::RenderView';
requires 'Moose';
requires 'namespace::autoclean';
requires 'Config::YAML';
requires 'Catalyst::View::Email';
test_requires 'Test::More' => '0.88';
catalyst;

install_script glob('script/*.pl');
auto_install;
WriteAll;
