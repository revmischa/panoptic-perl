package Panoptic::Form::Widget::Field::Text;

use Moose::Role;
with 'HTML::FormHandler::Widget::Field::Text';

has 'placeholder' => (
    is => 'rw',
    isa => 'Maybe[Str]',
);

has 'wrapper_attributes' => (
    is => 'rw',
    default => sub { { a => 1 }},
);

1;
