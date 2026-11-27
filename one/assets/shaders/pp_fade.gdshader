shader_type canvas_item;

uniform float fade: hint_range(0.0, 1.0, 0.05) = 0.0;
uniform sampler2D screen_texture: hint_screen_texture;


void fragment() {
	float vignette = length(UV * 2.0 - 1.0);
	vignette *= fade;
	
	vec3 screen = textureLod(screen_texture, SCREEN_UV, vignette * 4.0).rgb;
	
	vignette = 1.0 - vignette;
	COLOR.rgb = screen * vignette * vignette;
}
