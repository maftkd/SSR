using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DebugFragment : MonoBehaviour
{
    public Renderer renderer;

    public Camera cam;

    private List<Vector3> debugRays = new List<Vector3>();
    private Vector3 _viewSpaceNormal;

    private Matrix4x4 _tbn; 
    // Start is called before the first frame update
    void Start()
    {
    }

    // Update is called once per frame
    void Update()
    {
        Vector3 normal = -transform.forward;
        _viewSpaceNormal = cam.worldToCameraMatrix.MultiplyVector(normal);
        Vector3 tangent = Vector3.Cross(_viewSpaceNormal, Vector3.up).normalized;
        if (Vector3.Dot(tangent, tangent) < 0.1f)
        {
            tangent = Vector3.Cross(_viewSpaceNormal, Vector3.right).normalized;
            
        }
        Vector3 bitangent = Vector3.Cross(_viewSpaceNormal, tangent).normalized;
        _tbn = new Matrix4x4();
        _tbn.SetColumn(0, tangent);
        _tbn.SetColumn(1, bitangent);
        _tbn.SetColumn(2, _viewSpaceNormal);
        _tbn.SetColumn(3, new Vector4(0, 0, 0, 1));
        
        Color col = new Color(_viewSpaceNormal.x, _viewSpaceNormal.y, _viewSpaceNormal.z);
        renderer.material.color = col;

        float seed = _viewSpaceNormal.x + _viewSpaceNormal.y + _viewSpaceNormal.z;
        UnityEngine.Random.InitState((int)(seed * 1000));
        debugRays.Clear();
        for (int i = 0; i < 64; i++)
        {
            Vector3 ray = new Vector3(UnityEngine.Random.Range(-1f, 1f), UnityEngine.Random.Range(-1f, 1f), UnityEngine.Random.Range(0, 1f));
            ray.Normalize();
            debugRays.Add(ray);
        }
    }

    private void OnDrawGizmos()
    {
        if (_viewSpaceNormal != Vector3.zero)
        {
            Gizmos.color = Color.magenta;
            Gizmos.DrawRay(transform.position, _viewSpaceNormal);
        }
        if(debugRays != null && debugRays.Count > 0)
        {
            /*
            foreach (var ray in debugRays)
            {
                Gizmos.color = new Color(ray.x, ray.y, ray.z);
                Gizmos.DrawRay(transform.position, ray);
            }
            */

            foreach (var ray in debugRays)
            {
                Vector3 transformedRay = _tbn.MultiplyVector(ray);
                Gizmos.color = new Color(transformedRay.x, transformedRay.y, transformedRay.z);
                Gizmos.DrawLine(transform.position, transform.position + transformedRay * 0.5f);
                Gizmos.DrawSphere(transform.position + transformedRay * 0.5f, 0.01f);
                //Gizmos.DrawRay(transform.position, transformedRay);
                if (ray.y == 0)
                {
                    Gizmos.DrawSphere(transform.position + transformedRay * 0.5f, 0.5f);
                }
            }
        }
    }
}
