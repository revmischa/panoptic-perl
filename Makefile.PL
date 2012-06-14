#!/usr/bin/env perl
# IMPORTANT: if you delete this file your app will not work as
# expected.  You have been warned.
use inc::Module::Install;
use Module::Install::Catalyst; # Complain loudly if you don't have
                               # Catalyst::Devel installed or haven't said
                               # 'make dist' to create a standalone tarball.

name 'Panoptic';
all_from 'lib/Panoptic.pm';

# sudo aptitude install libdbd-pg-perl

requires 'Module::Install';
requires 'Catalyst::Runtime' => '5.80032';
requires 'Catalyst::Plugin::ConfigLoader';
requires 'Catalyst::Plugin::Static::Simple';
requires 'Catalyst::Action::RenderView';
requires 'Catalyst::Controller::DBIC::API::REST';
requires 'Moose';
requires 'MooseX::Storage';
requires 'MooseX::NonMoose';
requires 'namespace::autoclean';
requires 'Data::UUID';
requires 'Digest::SHA1';
requires 'Math::Round';
requires 'Math::Random::Secure';
requires 'Config::YAML';
requires 'Rapid';
requires 'Bread::Board';
requires 'Catalyst::Plugin::Bread::Board::Container';
requires 'Config::JFDI';
requires 'AnyEvent';
requires 'HTML::FormHandler::Moose';
requires 'HTML::FormHandler::Model::DBIC';
requires 'Net::Amazon::S3';
requires 'MooseX::NonMoose';

test_requires 'Test::More' => '0.88';
catalyst;

install_script glob('script/*.pl');
auto_install;
WriteAll;
