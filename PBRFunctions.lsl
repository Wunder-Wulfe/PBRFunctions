/**
    * Made by Wunder Wulfe!
    * PBR Function Helper Module.
    
    * Should be able to use in place of functions such as llSetLinkAlpha, llGetLinkAlpha, llSetLinkTexture, etc with minimal edits.
    * Compatible with all PBR materials.
    
    * Include in your scripts with the following line:
        #include "PBRFunctions.lsl"
        
    * Free to use with credit :)
    
    * Additional information / notes:
        - Colors are in Linear space, use llsRGB2Linear and llLinear2sRGB to convert between color spaces, or use the provided functions
        
        - If providing an empty Texture, it will not clear or overwrite the existing texture in the slot.
            Yes, this means you can still set other properties even if you can't access the texture!
        
        - All old functions that operate on Blinn-Phong material do not work on PBR materials, you have to use these versions!
        
        - If using preprocessor, unused functions will be removed on compile.
        
        - Most of the functions should work normally if you just replace original function calls with the provided alternatives.
        
        - 
*/


// llGetLinkAlpha for PBR materials
float GetLinkPBRAlpha(integer link, integer side)
{
    return llList2Float(
        llGetLinkPrimitiveParams(
            link, 
            [PRIM_GLTF_BASE_COLOR, side]
        ),
        5
    );
}

// llSetLinkAlpha for PBR Materials
SetLinkPBRAlpha(integer link, integer side, float alpha)
{
    llSetLinkPrimitiveParamsFast(
        link,  
        [PRIM_GLTF_BASE_COLOR, side] 
            + llListReplaceList(
                llGetLinkPrimitiveParams(
                    link, 
                    [PRIM_GLTF_BASE_COLOR, side]
                ),
                [alpha],
                5,
                5
            )
    );
}

// Allows setting of additional PBR alpha modes and alpha cutoff
// Valid alpha_modes: PRIM_GLTF_ALPHA_MODE_NONE, PRIM_GLTF_ALPHA_MODE_BLEND, PRIM_GLTF_ALPHA_MODE_MASK
SetLinkPBRAlphaAdv(integer link, integer side, float alpha, integer alpha_mode, float alpha_cutoff)
{
    llSetLinkPrimitiveParamsFast(
        link,  
        [PRIM_GLTF_BASE_COLOR, side] 
            + llListReplaceList(
                llGetLinkPrimitiveParams(
                    link, 
                    [PRIM_GLTF_BASE_COLOR, side]
                ),
                [alpha, alpha_mode, alpha_cutoff],
                5,
                7
            )
    );
}


// Get PBR material of a linked object
string GetLinkPBRMaterial(integer link, integer side)
{
    llList2String(
        llGetLinkPrimitiveParams(
            link,  
            [PRIM_RENDER_MATERIAL, side]
        ),
        0
    );
}

// Set PBR material of a linked object
SetLinkPBRMaterial(integer link, integer side, string material)
{
    llSetLinkPrimitiveParamsFast(
        link,  
        [PRIM_RENDER_MATERIAL, side, material]
    );
}


// llGetLinkColor for PBR Materials
vector GetLinkPBRBaseTintLinear(integer link, integer side)
{
    return llList2Vector(
        llGetLinkPrimitiveParams(
            link, 
            [PRIM_GLTF_BASE_COLOR, side]
        ),
        4
    );
}

// llGetLinkColor for PBR Materials (in sRGB space)
vector GetLinkPBRBaseTint(integer link, integer side)
{
    return llLinear2sRGB(
        llList2Vector(
            llGetLinkPrimitiveParams(
                link, 
                [PRIM_GLTF_BASE_COLOR, side]
            ),
            4
        )
    );
}

// llSetLinkColor for PBR materials
SetLinkPBRBaseTintLinear(integer link, integer side, vector tint)
{
    llSetLinkPrimitiveParamsFast(
        link,  
        [PRIM_GLTF_BASE_COLOR, side] 
            + llListReplaceList(
                llGetLinkPrimitiveParams(
                    link, 
                    [PRIM_GLTF_BASE_COLOR, side]
                ),
                [tint],
                4,
                4
            )
    );
}

// llSetLinkColor for PBR Materials (in sRGB space)
SetLinkPBRBaseTint(integer link, integer side, vector tint)
{
    llSetLinkPrimitiveParamsFast(
        link,  
        [PRIM_GLTF_BASE_COLOR, side] 
            + llListReplaceList(
                llGetLinkPrimitiveParams(
                    link, 
                    [PRIM_GLTF_BASE_COLOR, side]
                ),
                [llsRGB2Linear(tint)],
                4,
                4
            )
    );
}

// Get if the material uses Double Sided rendering mode
integer GetLinkPBRDoubleSided(integer link, integer side)
{
    return llList2Integer(
        llGetLinkPrimitiveParams(
            link, 
            [PRIM_GLTF_BASE_COLOR, side]
        ),
        8
    );
}

// Set if the material uses Double Sided rendering mode
SetLinkPBRDoubleSided(integer link, integer side, integer double_sided)
{
    llSetLinkPrimitiveParamsFast(
        link,  
        [PRIM_GLTF_BASE_COLOR, side] 
            + llListReplaceList(
                llGetLinkPrimitiveParams(
                    link, 
                    [PRIM_GLTF_BASE_COLOR, side]
                ),
                [double_sided],
                8,
                8
            )
    );
}

// llSetLinkTexture for PBR materials
SetLinkPBRBaseTexture(integer link, integer side, string tex)
{
    llSetLinkPrimitiveParamsFast(
        link,  
        [PRIM_GLTF_BASE_COLOR, side] 
            + llListReplaceList(
                llGetLinkPrimitiveParams(
                    link, 
                    [PRIM_GLTF_BASE_COLOR, side]
                ),
                [tex],
                0,
                0
            )
    );
}

// Advanced version of SetLinkPBRBaseTexture
SetLinkPBRBaseTextureAdv(integer link, integer side, string tex, vector repeats, vector offsets, float rotation_in_radians)
{
    llSetLinkPrimitiveParamsFast(
        link,  
        [PRIM_GLTF_BASE_COLOR, side] 
            + llListReplaceList(
                llGetLinkPrimitiveParams(
                    link, 
                    [PRIM_GLTF_BASE_COLOR, side]
                ),
                [tex, repeats, offsets, rotation_in_radians],
                0,
                3
            )
    );
}

// Set the PBR Normal Map texture
SetLinkPBRNormalTexture(integer link, integer side, string tex)
{
    llSetLinkPrimitiveParamsFast(
        link,  
        [PRIM_GLTF_NORMAL, side] 
            + llListReplaceList(
                llGetLinkPrimitiveParams(
                    link, 
                    [PRIM_GLTF_NORMAL, side]
                ),
                [tex],
                0,
                0
            )
    );
}

// Advanced version of SetLinkPBRNormalTexture
SetLinkPBRNormalTextureAdv(integer link, integer side, string tex, vector repeats, vector offsets, float rotation_in_radians)
{
    llSetLinkPrimitiveParamsFast(
        link,  
        [PRIM_GLTF_NORMAL, side] 
            + llListReplaceList(
                llGetLinkPrimitiveParams(
                    link, 
                    [PRIM_GLTF_NORMAL, side]
                ),
                [tex, repeats, offsets, rotation_in_radians],
                0,
                3
            )
    );
}

// Set the PBR Metallic Roughness texture
SetLinkPBRMetallicTexture(integer link, integer side, string tex)
{
    llSetLinkPrimitiveParamsFast(
        link,  
        [PRIM_GLTF_METALLIC_ROUGHNESS, side] 
            + llListReplaceList(
                llGetLinkPrimitiveParams(
                    link, 
                    [PRIM_GLTF_METALLIC_ROUGHNESS, side]
                ),
                [tex],
                0,
                0
            )
    );
}

// Advanced version of SetLinkPBRMetallicTexture
SetLinkPBRMetallicTextureAdv(integer link, integer side, string tex, vector repeats, vector offsets, float rotation_in_radians)
{
    llSetLinkPrimitiveParamsFast(
        link,  
        [PRIM_GLTF_METALLIC_ROUGHNESS, side] 
            + llListReplaceList(
                llGetLinkPrimitiveParams(
                    link, 
                    [PRIM_GLTF_METALLIC_ROUGHNESS, side]
                ),
                [tex, repeats, offsets, rotation_in_radians],
                0,
                3
            )
    );
}

// Get the Metallic factor of the PBR material
float GetLinkPBRMetallic(integer link, integer side)
{
    return llList2Float(
        llGetLinkPrimitiveParams(
            link, 
            [PRIM_GLTF_METALLIC_ROUGHNESS, side]
        ),
        4
    );
}

// Set the Metallic factor of the PBR material
SetLinkPBRMetallic(integer link, integer side, float metalness)
{
    llSetLinkPrimitiveParamsFast(
        link,  
        [PRIM_GLTF_METALLIC_ROUGHNESS, side] 
            + llListReplaceList(
                llGetLinkPrimitiveParams(
                    link, 
                    [PRIM_GLTF_METALLIC_ROUGHNESS, side]
                ),
                [metalness],
                4,
                4
            )
    );
}

// Get the Roughness factor of the PBR material
float GetLinkPBRRoughness(integer link, integer side)
{
    return llList2Float(
        llGetLinkPrimitiveParams(
            link, 
            [PRIM_GLTF_METALLIC_ROUGHNESS, side]
        ),
        5
    );
}

// Set the Roughness factor of the PBR material
SetLinkPBRRoughness(integer link, integer side, float roughness)
{
    llSetLinkPrimitiveParamsFast(
        link,  
        [PRIM_GLTF_METALLIC_ROUGHNESS, side] 
            + llListReplaceList(
                llGetLinkPrimitiveParams(
                    link, 
                    [PRIM_GLTF_METALLIC_ROUGHNESS, side]
                ),
                [roughness],
                5,
                5
            )
    );
}

// Set the Emissive texture of the PBR material
SetLinkPBREmissiveTexture(integer link, integer side, string tex)
{
    llSetLinkPrimitiveParamsFast(
        link,  
        [PRIM_GLTF_EMISSIVE, side] 
            + llListReplaceList(
                llGetLinkPrimitiveParams(
                    link, 
                    [PRIM_GLTF_EMISSIVE, side]
                ),
                [tex],
                0,
                0
            )
    );
}

// Set the Emissive "Tint" of the PBR material
SetLinkPBREmissiveTintLinear(integer link, integer side, vector tint)
{
    llSetLinkPrimitiveParamsFast(
        link,  
        [PRIM_GLTF_EMISSIVE, side] 
            + llListReplaceList(
                llGetLinkPrimitiveParams(
                    link, 
                    [PRIM_GLTF_EMISSIVE, side]
                ),
                [tint],
                4,
                4
            )
    );
}

// Set the Emissive "Tint" of the PBR material (in sRGB space)
SetLinkPBREmissiveTint(integer link, integer side, vector tint)
{
    llSetLinkPrimitiveParamsFast(
        link,  
        [PRIM_GLTF_EMISSIVE, side] 
            + llListReplaceList(
                llGetLinkPrimitiveParams(
                    link, 
                    [PRIM_GLTF_EMISSIVE, side]
                ),
                [llsRGB2Linear(tint)],
                4,
                4
            )
    );
}

// Get the Emissive "Tint" of the PBR material
vector GetLinkPBREmissiveTintLinear(integer link, integer side)
{
    return llList2Vector(
        llGetLinkPrimitiveParams(
            link, 
            [PRIM_GLTF_EMISSIVE, side]
        ),
        4
    );
}

// Get the Emissive "Tint" of the PBR material (in sRGB space)
vector GetLinkPBREmissiveTint(integer link, integer side, vector tint)
{
    return llLinear2sRGB(
        llList2Vector(
            llGetLinkPrimitiveParams(
                link, 
                [PRIM_GLTF_EMISSIVE, side]
            ),
            4
        )
    );
}
