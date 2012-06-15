package Panoptic::Form;

use HTML::FormHandler::Moose;
extends 'HTML::FormHandler';

use HTML::FormHandler::Render::Util qw/process_attrs ucc_widget/;

has '+widget_name_space' => ( default => sub { ['Panoptic::Form::Widget' ] } );

sub wrap_field {
    my ( $self, $field, $rendered_field ) = @_;

    return "\n$rendered_field" if $field->uwrapper eq 'none';
    return "\n$rendered_field" if ! $field->do_wrapper;

    my $output = "\n";

    my $wrapper_tag = $field->get_tag('wrapper_tag');
    $wrapper_tag ||= $field->has_flag('is_repeatable') ? 'fieldset' : 'div';
    my $attrs = process_attrs($field->wrapper_attributes);

    $output .= qq{<$wrapper_tag$attrs data-role="fieldcontain" class="ui-hide-label">};
    if ( $wrapper_tag eq 'fieldset' ) {
        $output .= '<legend>' . $field->loc_label . '</legend>';
    } elsif ( ! $field->get_tag('label_none') && $field->do_label && length( $field->label ) > 0 ) {
        $output .= "\n" . $self->render_label($field);
    }

    $output .= "\n$rendered_field";
    $output .= qq{\n<span class="error_message">$_</span>}
        for $field->all_errors;

    $output .= "\n</$wrapper_tag>";

    return "$output";
}

sub render_text {
    my ( $self, $field ) = @_;
    my $output = '<input type="' . $field->input_type . '" name="';
    $output .= $field->html_name . '"';
    $output .= ' id="' . $field->id . '"';
    $output .= ' size="' . $field->size . '"' if $field->size;
    $output .= ' maxlength="' . $field->maxlength . '"' if $field->maxlength;
    $output .= ' placeholder="' . $field->placeholder . '"' if $field->placeholder;
    $output .= ' value="' . $field->html_filter($field->fif) . '"';
    $output .= process_attrs($field->element_attributes);
    $output .= ' />';
    return $output;
}

__PACKAGE__->meta->make_immutable;
