#version 150

#moj_import <minecraft:fog.glsl>

uniform sampler2D Sampler0;

uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;

in float vertexDistance;
in vec4 vertexColor;
in vec4 lightMapColor;
in vec4 overlayColor;
in vec2 texCoord0;

out vec4 fragColor;

void main() {
    vec4 color = texture(Sampler0, texCoord0);
#ifdef ALPHA_CUTOUT
    if (color.a < ALPHA_CUTOUT) {
        discard;
    }
#endif
    vec4 NewoverlayColor = overlayColor;
    if(dot(overlayColor.rgb - vec3(1,0,0),overlayColor.rgb - vec3(1,0,0)) <= 0.00001){
        NewoverlayColor = vec4(163.0/255.0,1.0/255.0,160.0/255.0,1.0);
    }

    color *= vertexColor * ColorModulator;
#ifndef NO_OVERLAY
    color.rgb = mix(NewoverlayColor.rgb, color.rgb, overlayColor.a);
#endif
#ifndef EMISSIVE
    color *= lightMapColor;
#endif
    fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);
}
