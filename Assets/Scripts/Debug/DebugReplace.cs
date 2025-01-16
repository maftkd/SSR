using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DebugReplace : MonoBehaviour
{
    public Camera cam;

    public Shader shader;
    // Start is called before the first frame update
    void Start()
    {
        cam.SetReplacementShader(shader, "RenderType");
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
