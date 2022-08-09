using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ExampleReflectibleMissile : BaseReflectibleMissile
{
    public int MaxReflectTime = 5;

    private int currentReflectTime;

    private void Start()
    {
        currentReflectTime = 0;
    }

    private void OnEnable()
    {
        onReflectEvent += OnReflect;
    }

    private void OnDestroy()
    {
        onReflectEvent -= OnReflect;
    }


    [ContextMenu("LaunchTest")]
    public void LaunchMissileTest()
    {
        SetMissileVelocity(Vector2.left);
    }

    public void OnReflect()
    {
        currentReflectTime++;
        // Debug.Log("Reflect");
        if (currentReflectTime>MaxReflectTime)
        {
            Destroy(this.gameObject);
        }
    }
    
}
