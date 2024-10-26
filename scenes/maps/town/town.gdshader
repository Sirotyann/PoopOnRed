shader_type spatial;

uniform sampler2D bg_texture: source_color;
uniform sampler2D noise;

void vertex() {
	//float height = texture(noise, VERTEX.xz / 5.0).x;
	//VERTEX.y += height * 0.5;
	float radius = 100.0;
	//VERTEX.y = sin(VERTEX.x);
	//VERTEX.x = sqrt(radius * radius - VERTEX.y * VERTEX.y);
	VERTEX.x = sqrt(radius * radius - VERTEX.y * VERTEX.y);
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 bg = texture(bg_texture, UV);
	//NORMAL_MAP = bg.xyz;
	ALBEDO = bg.rgb;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
