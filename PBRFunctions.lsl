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

#define IS_EMPTY_VALUE(lst, index) ( llList2String(( lst ), ( index )) == "" )

#define LIST_REPLACE(lst, val, index) ( llListReplaceList(( lst ), (list)( val ), ( index ), ( index )) )

#define SET_LINK_GLTF(link, param, face, payload) llSetLinkPrimitiveParamsFast(( link ), [( param ), ( face )] + ( payload ))
#define GET_LINK_GLTF(link, param, face) llGetLinkPrimitiveParams(( link ), [( param ), ( face )])

list DefaultAssignGLTFBase(list result, integer USE_TEXTURE)
{
    if (!USE_TEXTURE)
        result = LIST_REPLACE(result, "", 0);
    
    // vector repeats
    if (IS_EMPTY_VALUE(result, 1))
        result = LIST_REPLACE(result, <1.0, 1.0, 0.0>, 1);
    
    // vector offsets
    if (IS_EMPTY_VALUE(result, 2))
        result = LIST_REPLACE(result, <0.0, 0.0, 0.0>, 2);
    
    // float rotation_in_radians
    if (IS_EMPTY_VALUE(result, 3))
        result = LIST_REPLACE(result, 0.0, 3);
    
    // vector linear_color
    if (IS_EMPTY_VALUE(result, 4))
        result = LIST_REPLACE(result, <1.0, 1.0, 1.0>, 4);
    
    // float alpha
    if (IS_EMPTY_VALUE(result, 5))
        result = LIST_REPLACE(result, 1.0, 5);
    
    // integer gltf_alpha_mode
    if (IS_EMPTY_VALUE(result, 6))
        result = LIST_REPLACE(result, PRIM_ALPHA_MODE_NONE, 6);
    
    // float alpha_mask_cutoff
    if (IS_EMPTY_VALUE(result, 7))
        result = LIST_REPLACE(result, 0.5, 7);
    
    // integer doublesided
    if (IS_EMPTY_VALUE(result, 8))
        result = LIST_REPLACE(result, FALSE, 8);
    
    return result;
}

list DefaultAssignGLTFNormal(list result, integer USE_TEXTURE)
{
    if (!USE_TEXTURE)
        result = LIST_REPLACE(result, "", 0);
    
    // vector repeats
    if (IS_EMPTY_VALUE(result, 1))
        result = LIST_REPLACE(result, <1.0, 1.0, 0.0>, 1);
    
    // vector offsets
    if (IS_EMPTY_VALUE(result, 2))
        result = LIST_REPLACE(result, <0.0, 0.0, 0.0>, 2);
    
    // float rotation_in_radians
    if (IS_EMPTY_VALUE(result, 3))
        result = LIST_REPLACE(result, 0.0, 3);
    
    return result;
}

list DefaultAssignGLTFMetallicRough(list result, integer USE_TEXTURE)
{
    if (!USE_TEXTURE)
        result = LIST_REPLACE(result, "", 0);
    
    // vector repeats
    if (IS_EMPTY_VALUE(result, 1))
        result = LIST_REPLACE(result, <1.0, 1.0, 0.0>, 1);
    
    // vector offsets
    if (IS_EMPTY_VALUE(result, 2))
        result = LIST_REPLACE(result, <0.0, 0.0, 0.0>, 2);
    
    // float rotation_in_radians
    if (IS_EMPTY_VALUE(result, 3))
        result = LIST_REPLACE(result, 0.0, 3);
        
    // float metallic_factor
    if (IS_EMPTY_VALUE(result, 4))
        result = LIST_REPLACE(result, 1.0, 4);
        
    // float roughness_factor
    if (IS_EMPTY_VALUE(result, 5))
        result = LIST_REPLACE(result, 1.0, 5);
    
    return result;
}

list DefaultAssignGLTFEmissive(list result, integer USE_TEXTURE)
{
    if (!USE_TEXTURE)
        result = LIST_REPLACE(result, "", 0);
    
    // vector repeats
    if (IS_EMPTY_VALUE(result, 1))
        result = LIST_REPLACE(result, <1.0, 1.0, 0.0>, 1);
    
    // vector offsets
    if (IS_EMPTY_VALUE(result, 2))
        result = LIST_REPLACE(result, <0.0, 0.0, 0.0>, 2);
    
    // float rotation_in_radians
    if (IS_EMPTY_VALUE(result, 3))
        result = LIST_REPLACE(result, 0.0, 3);
        
    // vector emissive_tint
    if (IS_EMPTY_VALUE(result, 4))
        result = LIST_REPLACE(result, <1.0, 1.0, 1.0>, 4);
        
    return result;
}

// llGetLinkAlpha for PBR materials
float GetLinkPBRAlpha(integer link, integer side)
{
    list details = GET_LINK_GLTF(link, PRIM_GLTF_BASE_COLOR, side);
    
    if (IS_EMPTY_VALUE(details, 5))
        return 1.0;
    else
        return llList2Float(details, 5);
}

// llSetLinkAlpha for PBR Materials
SetLinkPBRAlpha(integer link, integer side, float alpha)
{
    SET_LINK_GLTF(
        link,
        PRIM_GLTF_BASE_COLOR,
        side,
        DefaultAssignGLTFBase(
            LIST_REPLACE(
                GET_LINK_GLTF(link, PRIM_GLTF_BASE_COLOR, side),
                alpha,
                5
            ),
            FALSE
        )
    );
}

// Allows setting of additional PBR alpha modes and alpha cutoff
// Valid alpha_modes: PRIM_GLTF_ALPHA_MODE_NONE, PRIM_GLTF_ALPHA_MODE_BLEND, PRIM_GLTF_ALPHA_MODE_MASK
SetLinkPBRAlphaAdv(integer link, integer side, float alpha, integer alpha_mode, float alpha_cutoff)
{
    SET_LINK_GLTF(
        link,
        PRIM_GLTF_BASE_COLOR,
        side,
        DefaultAssignGLTFBase(
            llListReplaceList(
                GET_LINK_GLTF(link, PRIM_GLTF_BASE_COLOR, side),
                [alpha, alpha_mode, alpha_cutoff],
                5, 7
            ),
            FALSE
        )
    );
}


// Get PBR material of a linked object
string GetLinkPBRMaterial(integer link, integer side)
{
    llList2String(
        GET_LINK_GLTF(link, PRIM_RENDER_MATERIAL, side),
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
    list details = GET_LINK_GLTF(link, PRIM_GLTF_BASE_COLOR, side);
    
    if (IS_EMPTY_VALUE(details, 4))
        return <1.0, 1.0, 1.0>;
    else
        return llList2Vector(details, 4);
}

// llGetLinkColor for PBR Materials (in sRGB space)
vector GetLinkPBRBaseTint(integer link, integer side)
{
    list details = GET_LINK_GLTF(link, PRIM_GLTF_BASE_COLOR, side);
    
    if (IS_EMPTY_VALUE(details, 4))
        return <1.0, 1.0, 1.0>;
    else
        return llLinear2sRGB(llList2Vector(details, 4));
}

// llSetLinkColor for PBR materials
SetLinkPBRBaseTintLinear(integer link, integer side, vector tint)
{
    SET_LINK_GLTF(
        link,
        PRIM_GLTF_BASE_COLOR,
        side,
        DefaultAssignGLTFBase(
            LIST_REPLACE(
                GET_LINK_GLTF(link, PRIM_GLTF_BASE_COLOR, side),
                tint,
                4
            ),
            FALSE
        )
    );
}

// llSetLinkColor for PBR Materials (in sRGB space)
SetLinkPBRBaseTint(integer link, integer side, vector tint)
{
    SET_LINK_GLTF(
        link,
        PRIM_GLTF_BASE_COLOR,
        side,
        DefaultAssignGLTFBase(
            LIST_REPLACE(
                GET_LINK_GLTF(link, PRIM_GLTF_BASE_COLOR, side),
                llsRGB2Linear(tint),
                4
            ),
            FALSE
        )
    );
}

// Get if the material uses Double Sided rendering mode
integer GetLinkPBRDoubleSided(integer link, integer side)
{
    return llList2Integer(
        GET_LINK_GLTF(link, PRIM_GLTF_BASE_COLOR, side),
        8
    );
}

// Set if the material uses Double Sided rendering mode
SetLinkPBRDoubleSided(integer link, integer side, integer double_sided)
{
    SET_LINK_GLTF(
        link,
        PRIM_GLTF_BASE_COLOR,
        side,
        DefaultAssignGLTFBase(
            LIST_REPLACE(
                GET_LINK_GLTF(link, PRIM_GLTF_BASE_COLOR, side),
                double_sided,
                8
            ),
            FALSE
        )
    );
}

// llSetLinkTexture for PBR materials
SetLinkPBRBaseTexture(integer link, integer side, string tex)
{
    SET_LINK_GLTF(
        link,
        PRIM_GLTF_BASE_COLOR,
        side,
        DefaultAssignGLTFBase(
            LIST_REPLACE(
                GET_LINK_GLTF(link, PRIM_GLTF_BASE_COLOR, side),
                tex,
                0
            ),
            TRUE
        )
    );
}

// Advanced version of SetLinkPBRBaseTexture
SetLinkPBRBaseTextureAdv(integer link, integer side, string tex, vector repeats, vector offsets, float rotation_in_radians)
{
    SET_LINK_GLTF(
        link,
        PRIM_GLTF_BASE_COLOR,
        side,
        DefaultAssignGLTFBase(
            llListReplaceList(
                GET_LINK_GLTF(link, PRIM_GLTF_BASE_COLOR, side),
                [tex, repeats, offsets, rotation_in_radians],
                0, 3
            ),
            TRUE
        )
    );
}

// Set the PBR Normal Map texture
SetLinkPBRNormalTexture(integer link, integer side, string tex)
{
    SET_LINK_GLTF(
        link,
        PRIM_GLTF_NORMAL,
        side,
        DefaultAssignGLTFBase(
            LIST_REPLACE(
                GET_LINK_GLTF(link, PRIM_GLTF_NORMAL, side),
                tex,
                0
            ),
            TRUE
        )
    );
}

// Advanced version of SetLinkPBRNormalTexture
SetLinkPBRNormalTextureAdv(integer link, integer side, string tex, vector repeats, vector offsets, float rotation_in_radians)
{
    SET_LINK_GLTF(
        link,
        PRIM_GLTF_NORMAL,
        side,
        DefaultAssignGLTFBase(
            llListReplaceList(
                GET_LINK_GLTF(link, PRIM_GLTF_NORMAL, side),
                [tex, repeats, offsets, rotation_in_radians],
                0, 3
            ),
            TRUE
        )
    );
}

// Set the PBR Metallic Roughness texture
SetLinkPBRMetallicTexture(integer link, integer side, string tex)
{
    SET_LINK_GLTF(
        link,
        PRIM_GLTF_METALLIC_ROUGHNESS,
        side,
        DefaultAssignGLTFBase(
            LIST_REPLACE(
                GET_LINK_GLTF(link, PRIM_GLTF_METALLIC_ROUGHNESS, side),
                tex,
                0
            ),
            TRUE
        )
    );
}

// Advanced version of SetLinkPBRMetallicTexture
SetLinkPBRMetallicTextureAdv(integer link, integer side, string tex, vector repeats, vector offsets, float rotation_in_radians)
{
    SET_LINK_GLTF(
        link,
        PRIM_GLTF_METALLIC_ROUGHNESS,
        side,
        DefaultAssignGLTFBase(
            llListReplaceList(
                GET_LINK_GLTF(link, PRIM_GLTF_METALLIC_ROUGHNESS, side),
                [tex, repeats, offsets, rotation_in_radians],
                0, 3
            ),
            TRUE
        )
    );
}

// Get the Metallic factor of the PBR material
float GetLinkPBRMetallic(integer link, integer side)
{
    list details = GET_LINK_GLTF(link, PRIM_GLTF_METALLIC_ROUGHNESS, side);
    
    if (IS_EMPTY_VALUE(details, 4))
        return 1.0;
    else
        return llList2Float(details, 4);
}

// Set the Metallic factor of the PBR material
SetLinkPBRMetallic(integer link, integer side, float metalness)
{
    SET_LINK_GLTF(
        link,
        PRIM_GLTF_METALLIC_ROUGHNESS,
        side,
        DefaultAssignGLTFBase(
            LIST_REPLACE(
                GET_LINK_GLTF(link, PRIM_GLTF_METALLIC_ROUGHNESS, side),
                metalness,
                4
            ),
            FALSE
        )
    );
}

// Get the Roughness factor of the PBR material
float GetLinkPBRRoughness(integer link, integer side)
{
    list details = GET_LINK_GLTF(link, PRIM_GLTF_METALLIC_ROUGHNESS, side);
    
    if (IS_EMPTY_VALUE(details, 5))
        return 1.0;
    else
        return llList2Float(details, 5);
}

// Set the Roughness factor of the PBR material
SetLinkPBRRoughness(integer link, integer side, float roughness)
{
    SET_LINK_GLTF(
        link,
        PRIM_GLTF_METALLIC_ROUGHNESS,
        side,
        DefaultAssignGLTFBase(
            LIST_REPLACE(
                GET_LINK_GLTF(link, PRIM_GLTF_METALLIC_ROUGHNESS, side),
                roughness,
                5
            ),
            FALSE
        )
    );
}

// Set the Emissive texture of the PBR material
SetLinkPBREmissiveTexture(integer link, integer side, string tex)
{
    SET_LINK_GLTF(
        link,
        PRIM_GLTF_EMISSIVE,
        side,
        DefaultAssignGLTFBase(
            LIST_REPLACE(
                GET_LINK_GLTF(link, PRIM_GLTF_EMISSIVE, side),
                tex,
                0
            ),
            TRUE
        )
    );
}

// Advanced version of SetLinkPBREmissiveTexture
SetLinkPBREmissiveTextureAdv(integer link, integer side, string tex, vector repeats, vector offsets, float rotation_in_radians)
{
    SET_LINK_GLTF(
        link,
        PRIM_GLTF_EMISSIVE,
        side,
        DefaultAssignGLTFBase(
            llListReplaceList(
                GET_LINK_GLTF(link, PRIM_GLTF_EMISSIVE, side),
                [tex, repeats, offsets, rotation_in_radians],
                0, 3
            ),
            TRUE
        )
    );
}

// Set the Emissive "Tint" of the PBR material
SetLinkPBREmissiveTintLinear(integer link, integer side, vector tint)
{
    SET_LINK_GLTF(
        link,
        PRIM_GLTF_EMISSIVE,
        side,
        DefaultAssignGLTFBase(
            LIST_REPLACE(
                GET_LINK_GLTF(link, PRIM_GLTF_EMISSIVE, side),
                tint,
                4
            ),
            FALSE
        )
    );
}

// Set the Emissive "Tint" of the PBR material (in sRGB space)
SetLinkPBREmissiveTint(integer link, integer side, vector tint)
{
    SET_LINK_GLTF(
        link,
        PRIM_GLTF_EMISSIVE,
        side,
        DefaultAssignGLTFBase(
            LIST_REPLACE(
                GET_LINK_GLTF(link, PRIM_GLTF_EMISSIVE, side),
                llsRGB2Linear(tint),
                4
            ),
            FALSE
        )
    );
}

// Get the Emissive "Tint" of the PBR material
vector GetLinkPBREmissiveTintLinear(integer link, integer side)
{
    list details = GET_LINK_GLTF(link, PRIM_GLTF_EMISSIVE, side);
    
    if (IS_EMPTY_VALUE(details, 4))
        return <1.0, 1.0, 1.0>;
    else
        return llList2Vector(details, 4);
}

// Get the Emissive "Tint" of the PBR material (in sRGB space)
vector GetLinkPBREmissiveTint(integer link, integer side, vector tint)
{
    list details = GET_LINK_GLTF(link, PRIM_GLTF_EMISSIVE, side);
    
    if (IS_EMPTY_VALUE(details, 4))
        return <1.0, 1.0, 1.0>;
    else
        return llLinear2sRGB(llList2Vector(details, 4));
}
