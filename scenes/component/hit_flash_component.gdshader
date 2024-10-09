shader_type canvas_item;

uniform float lerp_percent : hint_range(0.0, 1.0);

// Called for every pixel the material is visible on.
void fragment() 
{
	// Get pixel color
	vec4 texture_color = texture(TEXTURE, UV);
	
	// Target all opaque pixels to white
	vec4 final_color = mix(texture_color, vec4(1.0,1.0,1.0, texture_color.a), lerp_percent);
	
	// Set Pixel Color
	COLOR = final_color;
}
