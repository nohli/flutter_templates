#version 460 core
#include <flutter/runtime_effect.glsl>

uniform vec2 uCenter;
uniform vec2 uHalfSize;
uniform float uRadius;
uniform float uWidth;
uniform float uPixelWidth;
uniform vec4 uColor;

out vec4 fragColor;

float roundedDistance(vec2 point, vec2 halfSize, float radius) {
  vec2 delta = abs(point) - halfSize + radius;
  return min(max(delta.x, delta.y), 0.0) + length(max(delta, 0.0)) - radius;
}

float coverage(float distance) {
  float pixelWidth = max(uPixelWidth, 0.0001);
  return clamp(0.5 - distance / pixelWidth, 0.0, 1.0);
}

void main() {
  vec2 point = FlutterFragCoord().xy - uCenter;
  float outside = coverage(roundedDistance(point, uHalfSize, uRadius));
  vec2 innerHalfSize = uHalfSize - uWidth;
  float inside = coverage(roundedDistance(point, innerHalfSize, max(uRadius - uWidth, 0.0)));
  if (min(innerHalfSize.x, innerHalfSize.y) <= 0.0) {
    inside = 0.0;
  }
  fragColor = uColor * clamp(outside - inside, 0.0, 1.0);
}
