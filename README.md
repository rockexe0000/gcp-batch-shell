




> ref: https://github.com/GoogleCloudPlatform/batch-samples/tree/main/busybox






### Service Account permissions

  - `Batch Agent Reporter`
    - RoleID: roles/batch.agentReporter
  - `Logs Writer`
    - RoleID: roles/logging.logWriter


## docker image

### setting GCP project & job runtime env
```
JOB_NAME="job-quickstart"
GCP_REGION="asia-east1"
GCP_PROJECT_ID="${GCP_PROJECT_ID}"
GCP_CONTAINER_REPO="${GCP_CONTAINER_REPO}"
IMAGE_URL="${GCP_REGION}-docker.pkg.dev/${GCP_PROJECT_ID}/${GCP_CONTAINER_REPO}/${JOB_NAME}"

NETWORK="${VPC_NETWORK}"
SUBNET="${VPC_SUBNET}"
SERVICE_ACCOUNT="${SERVICE_ACCOUNT_NAME}@${GCP_PROJECT_ID}.iam.gserviceaccount.com"
GCP_KEY_FILE="${GCP_KEY_FILE_PATH}"
JSON_CONFIGURATION_FILE="job.json"
```

### build docker image
```
docker build --platform linux/amd64 -f Dockerfile -t ${JOB_NAME} .
```

### 登入 GCP container Registry
```
cat "${GCP_KEY_FILE}" | docker login -u _json_key --password-stdin https://${GCP_REGION}-docker.pkg.dev
```

### push GCP container Registry
```
docker tag ${JOB_NAME} ${IMAGE_URL}:latest
docker push ${IMAGE_URL}:latest
```




### `gcloud batch jobs submit` 使用命令建立作業並執行

```
gcloud batch jobs submit ${JOB_NAME} \
    --location ${GCP_REGION} \
    --config ${JSON_CONFIGURATION_FILE}
```

#### JOB_NAME 可以加上時間戳記
```
### -`date +'%Y%m%d-%H%M%S'`

gcloud batch jobs submit ${JOB_NAME}-`date +'%Y%m%d-%H%M%S'` \
    --location ${GCP_REGION} \
    --config ${JSON_CONFIGURATION_FILE}
```

### `gcloud batch jobs delete` 使用命令刪除作業
```
gcloud batch jobs delete ${JOB_NAME} --location ${GCP_REGION}
```



### Use predefined environment variables

By default, the runnables in your job can use the following predefined environment variables:

-   `BATCH_TASK_COUNT`: the total number of tasks in this task group.
-   `BATCH_TASK_INDEX`: the index number of this task in the task group. The index of the first task is `0` and is incremented for each additional task.
-   `BATCH_HOSTS_FILE`: the path to a file listing all the running VM instances in this task group. To use this environment variable, the [`requireHostsFile` field](https://cloud.google.com/batch/docs/reference/rest/v1/projects.locations.jobs#taskgroup) must be set to `true`.
-   `BATCH_TASK_RETRY_ATTEMPT`: the number of times that this task has already been attempted. The value is `0` during the first attempt of a task and is incremented for each following retry. The total number of retries allowed for a task is determined by the value of the `maxRetryCount` field, which is `0` if undefined. For more information about retries, see [Automate task retries](https://cloud.google.com/batch/docs/automate-task-retries).











