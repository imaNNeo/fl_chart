#include <flutter/runtime_effect.glsl>

precision highp float;

uniform vec2 u_resolution;      
uniform float u_lineWidth;       
uniform float u_lineDistance;   
uniform float u_angle;          
uniform vec3 u_lineColor;

out vec4 sk_FragColor;

void main() {
    vec2 currentPos = FlutterFragCoord();
    vec2 center = u_resolution * 0.5;
    vec2 pos = currentPos.xy - center;

    float s = sin(u_angle);
    float c = cos(u_angle);
    vec2 rotated = vec2(
        pos.x * c - pos.y * s,
        pos.x * s + pos.y * c
    );

    float f = fract((rotated.y + center.y) / u_lineDistance);

    float thickness = u_lineWidth / u_lineDistance; // puoi regolare
    float isLine = step(f, thickness);

    vec3 color = u_lineColor;
    float alpha = isLine;

    sk_FragColor = vec4(color, alpha);
}
