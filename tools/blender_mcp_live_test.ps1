$code = @'
import bpy

for obj in list(bpy.context.scene.objects):
    if obj.name.startswith("WW_MCP_Live_Proof"):
        bpy.data.objects.remove(obj, do_unlink=True)

mat = bpy.data.materials.new("WW_MCP_Live_Clay_Red")
mat.diffuse_color = (0.72, 0.08, 0.04, 1.0)

bpy.ops.mesh.primitive_uv_sphere_add(segments=32, ring_count=16, radius=0.65, location=(2.0, 0.0, 0.75))
sphere = bpy.context.object
sphere.name = "WW_MCP_Live_Proof_Sphere"
sphere.data.name = "WW_MCP_Live_Proof_Sphere_Mesh"
sphere.data.materials.append(mat)
sphere["ww_mcp_proof"] = "live_control_ok"

bpy.ops.mesh.primitive_cube_add(size=1, location=(2.0, 0.0, 0.08))
base = bpy.context.object
base.name = "WW_MCP_Live_Proof_Base"
base.scale = (1.0, 1.0, 0.08)
base["ww_mcp_proof"] = "live_control_ok"

bpy.ops.object.select_all(action="DESELECT")
sphere.select_set(True)
bpy.context.view_layer.objects.active = sphere

result = {"created": [sphere.name, base.name], "proof": sphere.get("ww_mcp_proof")}
'@

$request = @{ type = "execute"; code = $code; strict_json = $true } | ConvertTo-Json -Compress
$bytes = [System.Text.Encoding]::UTF8.GetBytes($request + [char]0)

$client = [System.Net.Sockets.TcpClient]::new("127.0.0.1", 9876)
$stream = $client.GetStream()
$stream.Write($bytes, 0, $bytes.Length)

$buffer = New-Object byte[] 8192
$responseBytes = New-Object System.Collections.Generic.List[byte]
$deadline = (Get-Date).AddSeconds(8)

while ((Get-Date) -lt $deadline) {
    if ($stream.DataAvailable) {
        $read = $stream.Read($buffer, 0, $buffer.Length)
        if ($read -le 0) { break }
        for ($i = 0; $i -lt $read; $i++) {
            if ($buffer[$i] -eq 0) {
                $text = [System.Text.Encoding]::UTF8.GetString($responseBytes.ToArray())
                $client.Close()
                Write-Output $text
                exit 0
            }
            $responseBytes.Add($buffer[$i])
        }
    }
    Start-Sleep -Milliseconds 100
}

$client.Close()
Write-Error "Timed out waiting for Blender MCP response"
exit 1
