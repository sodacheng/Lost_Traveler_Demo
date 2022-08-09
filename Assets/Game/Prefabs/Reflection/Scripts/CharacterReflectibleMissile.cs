using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

//把这个脚本挂到要发射的物体身上
public class CharacterReflectibleMissile : MonoBehaviour
{
    public KeyCode LaunchKey = KeyCode.L;
    public float launchCD = 5f;
    public float missileSpeed = 10f;

    public bool canLaunch
    {
        get
        {
            if (currentCDTime>0)
            {
                return (Time.time > currentCDTime) ? true : false;
            }
            else
            {
                return true;
            }
        }
    }
    public GameObject MissilePrefab;

    private float currentCDTime;
    
    private void Update()
    {
        if (Input.GetKeyDown(LaunchKey)&&canLaunch)
        {
            currentCDTime = Time.time + launchCD;
            var missile = Instantiate(MissilePrefab, transform.position, Quaternion.identity);
            missile.GetComponent<ExampleReflectibleMissile>().SetMissileVelocity(missileSpeed*Vector2.right);
        }
    }
}
