data {
  int ns;
  int r[ns,2];
  int n[ns,2];
}
parameters{
  real mu[ns];
  real<lower=0> sd_;
  real d_raw;
  real delta_raw[ns];
  
}

transformed parameters {
  matrix[ns,2] p;

  real d;
  real delta[ns];
  
  

  d = 5*d_raw;


  for(i in 1:ns){
    // delta ~ normal(d,sd_)
    delta[i] = d + sd_*delta_raw[i];
    
    for(k in 1:2){
      if(k == 1){
        p[i,k] = inv_logit(mu[i]);
      } else {
        p[i,k] = inv_logit(mu[i] + delta[i]);
      }
    }
  }
}
model {
  
  target += normal_lpdf(d_raw| 0,1);
  
  for(i in 1:ns){
    target += normal_lpdf(delta_raw[i] | 0, 1);
    
    for(k in 1:2){
      target += binomial_lpmf(r[i,k]| n[i,k],p[i,k]);
    }
  }
}