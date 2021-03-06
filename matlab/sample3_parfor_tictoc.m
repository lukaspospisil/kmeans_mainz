clear all
path(pathdef);

%close all
addpath('ProblemGenerator/')
addpath('Plotting/')

% set random generator
randn('seed',13);
rand('seed',13);

K=3;

% problem parameters
Ts = [2000:2000:20000]; % number of points
N = 2; % dimension of the data

time_Gamma0 = zeros(length(Ts),1);
time_all = zeros(length(Ts),1);
time_Theta = zeros(length(Ts),1);
time_Gamma = zeros(length(Ts),1);
time_L = zeros(length(Ts),1);

for Tidx = 1:length(Ts)
    T = Ts(Tidx);
    
    disp(['T = ' num2str(T)])
    
    % generate problem
    X = generate_clustering(T,N);

    % run K-means algorithm
    % with one annealing step

    % generate random feasible gamma
    timer_Gamma0 = tic;
    
    Gamma = zeros(K,T);
    for t=1:T
        randidx = randi([1,K],1,1);
        Gamma(randidx,t) = 1;
    end
    
    time_Gamma0(Tidx) = toc(timer_Gamma0);
    
    it = 0;
    L = Inf;
    Theta = zeros(N,K);

    timer_all = tic;
    while it < 1000
        
        % solve Theta-problem
        timer_Theta = tic;
        
        for k=1:K
            sumgamma = sum(Gamma(k,:));
            if sumgamma ~= 0
                for n = 1:N
                    Theta(n,k) = dot(X(n,:),Gamma(k,:))/sumgamma;
                end
            end
        end
        
        time_Theta(Tidx) = time_Theta(Tidx) + toc(timer_Theta);
        
        % solve gamma problem
        timer_Gamma = tic;
        
        parfor t=1:T
            g = zeros(K,1);
            for k=1:K
                g(k) = dot(X(:,t) - Theta(:,k),X(:,t) - Theta(:,k));
            end
            
            v = zeros(K,1);
            [~,minidx] = min(g);
            v(minidx) = 1;
            Gamma(:,t) = v;
        end
        
        time_Gamma(Tidx) = time_Gamma(Tidx) + toc(timer_Gamma);
        
        % compute function value
        timer_L = tic;
        
        L_old = L;
        
        L = 0;
        for t=1:T
            for k=1:K
                L = L + ...
                  Gamma(k,t)*dot(X(:,t) - Theta(:,k),X(:,t) - Theta(:,k));
            end
        end
        L = L/(T*N);
        
        time_L(Tidx) = time_L(Tidx) + toc(timer_L);
        
        % check stopping criteria
        Ldelta = L_old - L;
        if Ldelta < 1e-6
            break;
        end
        
        it = it + 1;
    end

    time_all(Tidx) = toc(timer_all)/it;
    time_Theta(Tidx) = time_Theta(Tidx)/it;
    time_Gamma(Tidx) = time_Gamma(Tidx)/it;
    time_L(Tidx) = time_L(Tidx)/it;
end

clear Gamma X Theta g
save('results/kmeans3b.mat')

