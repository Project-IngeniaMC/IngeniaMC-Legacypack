#version 150

#moj_import <fog.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV2;

uniform sampler2D Sampler2;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform int FogShape;
uniform float GameTime;
uniform vec2 ScreenSize;

out float vertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;

void main() {
    // vanilla behavior
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);
    vertexDistance = length((ModelViewMat * vec4(Position, 1.0)).xyz);
    vertexColor = Color * texelFetch(Sampler2, UV2 / 16, 0);
    texCoord0 = UV0;
    float timeLoop = GameTime * 1200;
    vec3 col = 0.5 + 0.5*cos(vec3(timeLoop, timeLoop, timeLoop) + vec3(0,2,4));
    // NoShadow behavior (https://github.com/PuckiSilver/NoShadow)
    if (Color.xyz == vec3(78/255., 92/255., 36/255.) && (
        Position.z == 0.03 || // Actionbar
        Position.z == 0.06 || // Subtitle
        Position.z == 0.12 || // Title
        Position.z == 100.03 || // Chat
        Position.z == 200.03 || // Advancement Screen
        Position.z == 400.03    // Items
        )) {
        vertexColor = vec4(col,Color.w) * texelFetch(Sampler2, UV2 / 16, 0); // remove color from no shadow marker
    }
}