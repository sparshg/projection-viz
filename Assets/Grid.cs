using UnityEngine;
using System.Collections.Generic;

[RequireComponent(typeof(MeshRenderer))]
[RequireComponent(typeof(MeshFilter))]
[ExecuteInEditMode]
public class GridMesh : MonoBehaviour
{
    public int GridSize;
    public int GridSpacing;

    void Awake()
    {
        MeshFilter filter = gameObject.GetComponent<MeshFilter>();
        transform.position = new Vector3(-GridSize * GridSpacing / 2f, 0, -GridSize * GridSpacing / 2f);
        var mesh = new Mesh();
        var verticies = new List<Vector3>();

        var indicies = new List<int>();
        for (int i = 0; i < GridSize; i++)
        {
            verticies.Add(new Vector3(i * GridSpacing, 0, 0));
            verticies.Add(new Vector3(i * GridSpacing, 0, GridSize * GridSpacing));

            indicies.Add(4 * i + 0);
            indicies.Add(4 * i + 1);

            verticies.Add(new Vector3(0, 0, i * GridSpacing));
            verticies.Add(new Vector3(GridSize * GridSpacing, 0, i * GridSpacing));

            indicies.Add(4 * i + 2);
            indicies.Add(4 * i + 3);
        }

        mesh.vertices = verticies.ToArray();
        mesh.SetIndices(indicies.ToArray(), MeshTopology.Lines, 0);
        filter.mesh = mesh;

    }
}