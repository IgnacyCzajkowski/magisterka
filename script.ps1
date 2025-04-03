<#
$input_files = @(
                ".\params_dir\pv2_rb_ba_1.txt", ".\params_dir\pv2_rb_ba_2.txt", ".\params_dir\pv2_rb_ba_3.txt", ".\params_dir\pv2_rb_ba_4.txt",
                ".\params_dir\pv2_rb_ba_5.txt", ".\params_dir\pv2_rb_ba_6.txt", ".\params_dir\pv2_rb_ba_7.txt", ".\params_dir\pv2_rb_ba_8.txt",
                ".\params_dir\pv2_rb_ba_9.txt", ".\params_dir\pv2_rb_ba_10.txt", ".\params_dir\pv2_rb_ba_11.txt", ".\params_dir\pv2_rb_ba_12.txt",
                ".\params_dir\pv2_rb_ba_13.txt", ".\params_dir\pv2_rb_ba_14.txt", ".\params_dir\pv2_rb_ba_15.txt", ".\params_dir\pv2_rb_ba_16.txt",
                ".\params_dir\pv2_rb_er_1.txt", ".\params_dir\pv2_rb_er_2.txt", ".\params_dir\pv2_rb_er_3.txt", ".\params_dir\pv2_rb_er_4.txt",
                ".\params_dir\pv2_rb_er_5.txt", ".\params_dir\pv2_rb_er_6.txt", ".\params_dir\pv2_rb_er_7.txt", ".\params_dir\pv2_rb_er_8.txt",
                ".\params_dir\pv2_rb_er_9.txt", ".\params_dir\pv2_rb_er_10.txt", ".\params_dir\pv2_rb_er_11.txt", ".\params_dir\pv2_rb_er_12.txt",
                ".\params_dir\pv2_rb_er_13.txt", ".\params_dir\pv2_rb_er_14.txt", ".\params_dir\pv2_rb_er_15.txt", ".\params_dir\pv2_rb_er_16.txt"
)
#>

$input_files = @(
    ".\params_dir\pv1_ifn_bn04_b03_ba_4.txt", ".\params_dir\pv1_ifn_bn04_b03_er_4.txt",
    ".\params_dir\pv1_ifn_bn04_b05_ba_4.txt", ".\params_dir\pv1_ifn_bn04_b05_er_4.txt",
    ".\params_dir\pv1_ifn_bn04_b07_ba_4.txt", ".\params_dir\pv1_ifn_bn04_b07_er_4.txt",
    ".\params_dir\pv1_ifn_bn04_b09_ba_4.txt", ".\params_dir\pv1_ifn_bn04_b09_er_4.txt",

    ".\params_dir\pv1_ifn_bn06_b03_ba_4.txt", ".\params_dir\pv1_ifn_bn06_b03_er_4.txt",
    ".\params_dir\pv1_ifn_bn06_b05_ba_4.txt", ".\params_dir\pv1_ifn_bn06_b05_er_4.txt",
    ".\params_dir\pv1_ifn_bn06_b07_ba_4.txt", ".\params_dir\pv1_ifn_bn06_b07_er_4.txt",
    ".\params_dir\pv1_ifn_bn06_b09_ba_4.txt", ".\params_dir\pv1_ifn_bn06_b09_er_4.txt",

    ".\params_dir\pv1_ifn_bn08_b03_ba_4.txt", ".\params_dir\pv1_ifn_bn08_b03_er_4.txt",
    ".\params_dir\pv1_ifn_bn08_b05_ba_4.txt", ".\params_dir\pv1_ifn_bn08_b05_er_4.txt",
    ".\params_dir\pv1_ifn_bn08_b07_ba_4.txt", ".\params_dir\pv1_ifn_bn08_b07_er_4.txt",
    ".\params_dir\pv1_ifn_bn08_b09_ba_4.txt", ".\params_dir\pv1_ifn_bn08_b09_er_4.txt"
)

$prefix = ".\wyniki_nowe\propv1\rozne_bety\nowe\"

$output_files = @(
    "${prefix}b04bn03ba.txt", "${prefix}b04bn03er.txt",
    "${prefix}b04bn05ba.txt", "${prefix}b04bn05er.txt",
    "${prefix}b04bn07ba.txt", "${prefix}b04bn07er.txt",
    "${prefix}b04bn09ba.txt", "${prefix}b04bn09er.txt",
    
    "${prefix}b06bn03ba.txt", "${prefix}b06bn03er.txt",
    "${prefix}b06bn05ba.txt", "${prefix}b06bn05er.txt",
    "${prefix}b06bn07ba.txt", "${prefix}b06bn07er.txt",
    "${prefix}b06bn09ba.txt", "${prefix}b06bn09er.txt",
    
    "${prefix}b08bn03ba.txt", "${prefix}b08bn03er.txt",
    "${prefix}b08bn05ba.txt", "${prefix}b08bn05er.txt",
    "${prefix}b08bn07ba.txt", "${prefix}b08bn07er.txt",
    "${prefix}b08bn09ba.txt", "${prefix}b08bn09er.txt"
)
<#
$output_files = @("${prefix_ba}1_03.txt", "${prefix_ba}1_03_03.txt", "${prefix_ba}1_03_03_03.txt", "${prefix_ba}1_03_03_03_03.txt",
                "${prefix_ba}1_05.txt", "${prefix_ba}1_05_05.txt", "${prefix_ba}1_05_05_05.txt", "${prefix_ba}1_05_05_05_05.txt",
                "${prefix_ba}1_07.txt", "${prefix_ba}1_07_07.txt", "${prefix_ba}1_07_07_07.txt", "${prefix_ba}1_07_07_07_07.txt",
                "${prefix_ba}1_09.txt", "${prefix_ba}1_09_09.txt", "${prefix_ba}1_09_09_09.txt", "${prefix_ba}1_09_09_09_09.txt",
                "${prefix_er}1_03.txt", "${prefix_er}1_03_03.txt", "${prefix_er}1_03_03_03.txt", "${prefix_er}1_03_03_03_03.txt",
                "${prefix_er}1_05.txt", "${prefix_er}1_05_05.txt", "${prefix_er}1_05_05_05.txt", "${prefix_er}1_05_05_05_05.txt",
                "${prefix_er}1_07.txt", "${prefix_er}1_07_07.txt", "${prefix_er}1_07_07_07.txt", "${prefix_er}1_07_07_07_07.txt",
                "${prefix_er}1_09.txt", "${prefix_er}1_09_09.txt", "${prefix_er}1_09_09_09.txt", "${prefix_er}1_09_09_09_09.txt")
#>


for ($i=0; $i -lt $input_files.Length; $i++) {
    Write-Host "julia -t auto src\parallel_main.jl $($input_files[$i]) $($output_files[$i])" 
    Start-Process -NoNewWindow -Wait -FilePath "julia" -ArgumentList @("-t", "auto", "src\parallel_main.jl", $input_files[$i], $output_files[$i])
    Write-Host "Running script: ($($i)/$($input_files.Length))"
}                   