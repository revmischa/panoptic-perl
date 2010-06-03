#!/usr/bin/env perl
use inc::Module::Install;

name 'Int80';
all_from 'lib/Int80.pm';

requires 'Catalyst::Runtime' => '5.80021';

requires 'Catalyst::Plugin::ConfigLoader';
requires 'Catalyst::Plugin::Static::Simple';
requires 'Catalyst::Action::RenderView';
requires 'Catalyst::View::Email';
requires 'Catalyst::View::JSON';
requires 'Catalyst::View::TT';
requires 'Catalyst::TraitFor::Request::REST::ForBrowsers';
requires 'Catalyst::Controller::DBIC::API::REST';
requires 'Catalyst::Model::DBIC::Schema';
requires 'Catalyst::Plugin::Session::Store::FastMmap';
requires 'Catalyst::Plugin::Session::State::Cookie';

requires 'Moose';
requires 'namespace::autoclean';
requires 'Config::YAML';
requires 'JSON::XS';

test_requires 'Test::More' => '0.88';
catalyst;

install_script glob('script/*.pl');
auto_install;
WriteAll;
