shader_type canvas_item;

uniform vec4 R_Replace : hint_color;
uniform vec4 G_Replace :  hint_color;
uniform vec4 B_Replace : hint_color;
uniform vec4 Default :  hint_color;
uniform bool ReplaceCol = true;


void fragment() {
    vec4 rgba_in = texture(TEXTURE, UV);


    // color defaults to the black replacement color
    vec3 rgb_out = Default.rgb;
    if (ReplaceCol == true)
	{
    // mix in other colors based on the red, green and blue components of the source image
		rgb_out = mix(rgb_out, R_Replace.rgb, rgba_in.r);
		rgb_out = mix(rgb_out, G_Replace.rgb, rgba_in.g);
		rgb_out = mix(rgb_out, B_Replace.rgb, rgba_in.b);
		COLOR = vec4(rgb_out.rgb, rgba_in.a);
    }
	else {
		COLOR = rgba_in
		}
    // Assign final color for the pixel, and preserve transparency
}