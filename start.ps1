# Check if the Jenkins image exists, if not, build it
$imageExists = docker images -q jenkins-server 2>$null
if (-not $imageExists) {
    Write-Output "Building custom image: jenkins-server..."
    docker build -t jenkins-server ./jenkins
    if ($LASTEXITCODE -ne 0) {
        Write-Output "Failed to build jenkins-server image. Exiting."
        exit 1
    }
} else {
    Write-Output "Image jenkins-server already exists. Skipping build."
}

docker-compose up
if ($LASTEXITCODE -ne 0) {
    Write-Output "Failed to start Docker Compose. Exiting."
    exit 1
}