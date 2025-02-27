shader_type canvas_item;

uniform vec4 R_Replace : source_color;
uniform vec4 G_Replace :  source_color;
uniform vec4 B_Replace : source_color;
uniform vec4 Default :  source_color;
uniform bool ReplaceCol = true;


void fragment() {
    vec4 rgba_in = texture(TEXTURE, UV);


    // color defaults to the black replacement color
    vec4 rgb_out = Default.rgba;
    if (ReplaceCol == true)
	{
    // mix in other colors based on the red, green and blue components of the source image
		//rgb_out = mix(rgb_out, G_Replace.rgba, rgba_in.g);
		rgb_out = mix(rgb_out, R_Replace.rgba, rgba_in.r);

		rgb_out = mix(rgb_out, B_Replace.rgba, rgba_in.b);
		//rgb_out.r = G_Replace
		COLOR = vec4(rgb_out.r,rgb_out.g,rgb_out.b,rgba_in.g);
    }
	else {
		COLOR = rgba_in;
		}
    // Assign final color for the pixel, and preserve transparency
}