include utils/meta.mk utils/help.mk

run-cluster-linux: ##@local Run a full cluster of 3 nodes 
run-cluster-linux:
	@$(SHELL_EXPORT) docker-compose -f docker-compose-linux.yaml up -d ipfs0 ipfs1 ipfs2
	@$(SHELL_EXPORT) docker-compose -f docker-compose-linux.yaml run wait -c ipfs0:5001,ipfs1:5001,ipfs2:5001
	@$(SHELL_EXPORT) docker-compose -f docker-compose-linux.yaml up -d cluster0 cluster1 cluster2

run-cluster-mac: ##@local Run a simple cluster of 3 nodes
run-cluster-mac:
	@$(SHELL_EXPORT) docker-compose -f docker-compose-mac.yaml up -d

stop-cluster: ##@local Stop entire cluster
stop-cluster:
	@$(SHELL_EXPORT) docker-compose stop

clear-cluster: ##@local Clear cluster
clear-cluster:
	@$(SHELL_EXPORT) docker-compose down
	sudo rm -Rf cluster-data

build-kubernetes: ##@devops Generate proper k8s files based on the templates
build-kubernetes: ./k8s
	@rm -Rf $(K8S_BUILD_DIR) && mkdir -p $(K8S_BUILD_DIR)
	@for file in $(K8S_FILES); do \
		mkdir -p `dirname "$(K8S_BUILD_DIR)/$$file"`; \
		$(SHELL_EXPORT) envsubst <./k8s/$$file >$(K8S_BUILD_DIR)/$$file; \
	done

deploy-kubernetes: ##@devops Publish the build k8s files
deploy-kubernetes: $(K8S_BUILD_DIR) ./build_k8s
	@kubectl apply -f build_k8s -n $(NAMESPACE)
