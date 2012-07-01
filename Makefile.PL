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
requires 'Catalyst::Runtime' => '5.90012';
requires 'Catalyst::Plugin::ConfigLoader';
requires 'Catalyst::Plugin::Static::Simple';
requires 'Catalyst::Action::RenderView';
requires 'Catalyst::Controller::DBIC::API' => '2.002001';
requires 'Catalyst::Plugin::Session::Store::DBIC' => '0.12';
requires 'Catalyst::Plugin::ErrorCatcher';
requires 'Catalyst::Plugin::LogWarnings';
requires 'Catalyst::Plugin::Session::State::Cookie' => '0.17';
requires 'Catalyst::Plugin::Authorization::ACL' => '0.15';
requires 'Catalyst::Model::DBIC::Schema' => '0.60';
requires 'CatalystX::REPL';
requires 'CatalystX::Component::Traits' => '0.16';
requires 'Moose' => '2.0602';
requires 'MooseX::Storage';
requires 'MooseX::NonMoose';
requires 'MooseX::Traits::Pluggable' => '0.10';
requires 'MooseX::SemiAffordanceAccessor' => '0.09';
requires 'MooseX::Role::BuildInstanceOf' => '0.08';
requires 'namespace::autoclean';
requires 'Data::UUID';
requires 'MIME::Base64';
requires 'Data::Stream::Bulk' => '0.11';
requires 'DateTime::Format::Strptime' => '1.51';
requires 'Digest::SHA1';
requires 'Math::Round';
requires 'Math::Random::Secure';
requires 'Config::YAML';
requires 'Rapid';
requires 'Bread::Board';
requires 'Catalyst::Plugin::Bread::Board::Container';
requires 'Config::JFDI';
requires 'AnyEvent';
requires 'AnyEvent::HTTP';
requires 'LWP::Protocol::AnyEvent::http';
requires 'HTML::FormHandler::Moose';
requires 'HTML::FormHandler::Model::DBIC';
requires 'Net::Amazon::S3';
requires 'MooseX::NonMoose';
requires 'Exporter::Tidy';
requires 'JSON::XS';
requires 'Data::Dump';
requires 'DateTime::Format::Pg';
requires 'Template::Plugin::JSON';

# optional
requires 'Devel::Cycle';
requires 'Catalyst::Devel';
requires 'File::ChangeNotify::Watcher' => '0.22';

test_requires 'Test::More' => '0.88';
catalyst;

install_script glob('script/*.pl');
auto_install;
WriteAll;
