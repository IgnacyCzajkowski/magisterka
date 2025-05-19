 

$input_files = @(
    ".\params_dir_new\pv1_bm1_bn03_er.txt", ".\params_dir_new\pv1_bm1_bn05_er.txt",
    ".\params_dir_new\pv1_bm1_bn07_er.txt", ".\params_dir_new\pv1_bm1_bn09_er.txt",
    ".\params_dir_new\pv1_bm08_bn03_er.txt", ".\params_dir_new\pv1_bm08_bn05_er.txt",
    ".\params_dir_new\pv1_bm08_bn07_er.txt", ".\params_dir_new\pv1_bm08_bn09_er.txt",
    ".\params_dir_new\pv1_bm06_bn03_er.txt", ".\params_dir_new\pv1_bm06_bn05_er.txt",
    ".\params_dir_new\pv1_bm06_bn07_er.txt", ".\params_dir_new\pv1_bm06_bn09_er.txt",
    ".\params_dir_new\pv1_bm04_bn03_er.txt", ".\params_dir_new\pv1_bm04_bn05_er.txt",
    ".\params_dir_new\pv1_bm04_bn07_er.txt", ".\params_dir_new\pv1_bm04_bn09_er.txt",

    ".\params_dir_new\pv1_bm1_bn03_ba.txt", ".\params_dir_new\pv1_bm1_bn05_ba.txt",
    ".\params_dir_new\pv1_bm1_bn07_ba.txt", ".\params_dir_new\pv1_bm1_bn09_ba.txt",
    ".\params_dir_new\pv1_bm08_bn03_ba.txt", ".\params_dir_new\pv1_bm08_bn05_ba.txt",
    ".\params_dir_new\pv1_bm08_bn07_ba.txt", ".\params_dir_new\pv1_bm08_bn09_ba.txt",
    ".\params_dir_new\pv1_bm06_bn03_ba.txt", ".\params_dir_new\pv1_bm06_bn05_ba.txt",
    ".\params_dir_new\pv1_bm06_bn07_ba.txt", ".\params_dir_new\pv1_bm06_bn09_ba.txt",
    ".\params_dir_new\pv1_bm04_bn03_ba.txt", ".\params_dir_new\pv1_bm04_bn05_ba.txt",
    ".\params_dir_new\pv1_bm04_bn07_ba.txt", ".\params_dir_new\pv1_bm04_bn09_ba.txt"
)

<#
$prefix_ba = ".\wyniki_nowe\propv1\rozne_bety\ba\"
$prefix_er = ".\wyniki_nowe\propv1\rozne_bety\er\"
#>

$prefix_email = ".\wyniki_nowe\propv1\rozne_bety\email\"
$prefix_er = ".\wyniki_nowe\propv1\rozne_bety\er\"
$prefix_ba = ".\wyniki_nowe\propv1\rozne_bety\ba\"

$output_files = @(
                "${prefix_er}1_03_03_03_03.txt", "${prefix_er}1_05_05_05_05.txt",
                "${prefix_er}1_07_07_07_07.txt", "${prefix_er}1_09_09_09_09.txt",
                "${prefix_er}08_03_03_03_03.txt", "${prefix_er}08_05_05_05_05.txt",
                "${prefix_er}08_07_07_07_07.txt", "${prefix_er}08_09_09_09_09.txt",
                "${prefix_er}06_03_03_03_03.txt", "${prefix_er}06_05_05_05_05.txt",
                "${prefix_er}06_07_07_07_07.txt", "${prefix_er}06_09_09_09_09.txt",
                "${prefix_er}04_03_03_03_03.txt", "${prefix_er}04_05_05_05_05.txt",
                "${prefix_er}04_07_07_07_07.txt", "${prefix_er}04_09_09_09_09.txt",

                "${prefix_ba}1_03_03_03_03.txt", "${prefix_ba}1_05_05_05_05.txt",
                "${prefix_ba}1_07_07_07_07.txt", "${prefix_ba}1_09_09_09_09.txt",
                "${prefix_ba}08_03_03_03_03.txt", "${prefix_ba}08_05_05_05_05.txt",
                "${prefix_ba}08_07_07_07_07.txt", "${prefix_ba}08_09_09_09_09.txt",
                "${prefix_ba}06_03_03_03_03.txt", "${prefix_ba}06_05_05_05_05.txt",
                "${prefix_ba}06_07_07_07_07.txt", "${prefix_ba}06_09_09_09_09.txt",
                "${prefix_ba}04_03_03_03_03.txt", "${prefix_ba}04_05_05_05_05.txt",
                "${prefix_ba}04_07_07_07_07.txt", "${prefix_ba}04_09_09_09_09.txt"
                
                )



for ($i=0; $i -lt $input_files.Length; $i++) {
    Write-Host "julia -t auto src\parallel_main.jl $($input_files[$i]) $($output_files[$i])" 
    Start-Process -NoNewWindow -Wait -FilePath "julia" -ArgumentList @("-t", "auto", "src\parallel_main.jl", $input_files[$i], $output_files[$i])
    Write-Host "Running script: ($($i)/$($input_files.Length))"
}                   