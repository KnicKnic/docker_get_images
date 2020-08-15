
$DOCKER_HUB_USER=$env:DOCKER_HUB_USER
$DOCKER_HUB_ORG=$env:DOCKER_HUB_ORG
$DOCKER_HUB_PASSWORD=$env:DOCKER_HUB_PASSWORD



$request = Invoke-RestMethod -Body  @{'username' = $DOCKER_HUB_USER; 'password' = $DOCKER_HUB_PASSWORD} -Method Post 'https://hub.docker.com/v2/users/login/'

$token = $request.token | ConvertTo-SecureString -AsPlainText -Force
$repo_list =  Invoke-RestMethod -Authentication Bearer -Token $token "https://hub.docker.com/v2/repositories/$($DOCKER_HUB_ORG)/?page_size=100" 

$linux_images = @()
$windows_images = @()

Write-Output $repo_list
foreach ($repo in $repo_list.results) {
    $img_list =  Invoke-RestMethod -Authentication Bearer -Token $token  "https://hub.docker.com/v2/repositories/$($DOCKER_HUB_ORG)/$($repo.name)/tags/?page_size=100"

    foreach($imgs in $img_list.results ){
        $is_windows = $false
        $is_linux  = $false
        foreach($img in $imgs.images){
            if($img.os -eq "windows"){
                $is_windows = $true
            }
            if($img.os -eq "linux"){
                $is_linux = $true
            }
        }
        if($is_windows){
            $windows_images += "$($DOCKER_HUB_ORG)/$($repo.name):$($imgs.name)"
        }
        if($is_linux){
            $linux_images += "$($DOCKER_HUB_ORG)/$($repo.name):$($imgs.name)"
        }
    }
    # Write-Output $img_list  
}

docker login -u $DOCKER_HUB_USER -p $DOCKER_HUB_PASSWORD

Write-Output "linux images"  $linux_images
write-output "windows image" $windows_images


if($IsWindows){
    foreach($image in $windows_images){
        docker pull $image
    }
}

if($IsLinux){
    foreach($image in $linux_images){
        docker pull $image
    }
}