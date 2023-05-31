# ter_aws_rock
> This project creates AWS EKS Cluster and *Deploy there my Portfolio* .
Before you start creating, you'll need the following:

    1. an AWS account;
    2. identity and access management (IAM) credentials and programmatic access;
    3. AWS credentials that are set up locally with aws configure;
    4. a Virtual Private Cloud configured for EKS; and
    5. a code or text editor, like VS Code.

export AWS_ACCESS_KEY_ID=      
    
export AWS_SECRET_ACCESS_KEY=   
   
terraform init
terraform apply -auto-approve
    
after creating resources run
    
aws eks --region <region> update-kubeconfig --name <cluster-name>

kubectl apply -f deploy.yaml
    
In Route 53 create HOSTED ZONE and create A record with ALIAS to LoadBalancer endpoint
    
Done !
