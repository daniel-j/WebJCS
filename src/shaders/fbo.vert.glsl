
attribute vec2 position;
varying vec2 texcoord;

void main() {
	gl_Position = vec4(position, 0.0, 1.0);
	texcoord = position.xy * 0.5 + 0.5;
}
