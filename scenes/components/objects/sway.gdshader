shader_type spatial;

void vertex()
{
	VERTEX.y += sin((VERTEX.x + TIME) * 0.2f) * 32.0f;
}
