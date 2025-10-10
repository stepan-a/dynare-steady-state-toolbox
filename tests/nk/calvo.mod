// Declaration of the endogenous variables.
var Efficiency                  $A$ 
    RiskPremium                 $B$
    a                           $a$
    b                           $b$
    Dist                        $\Delta$
    Theta                       $\Theta$
    Consumption                 $C$
    Lambda                      $\lambda$
    RealWage                    $\omega$
    Inflation                   $\pi$
    NominalInterestRate         $i$
    Output                      $Y$
    RelativePrice               $p$
    Hours                       $h$
    Z1                          $\mathcal Z_1$
    Z2                          $\mathcal Z_2$
    Z3                          $\mathcal Z_3$
    Exp1                        $\mathcal E_1$
    Exp2                        $\mathcal E_2$
    Exp3                        $\mathcal E_3$
    Exp4                        $\mathcal E_4$
;

// Declaration of the exogenous variables.
varexo ea                       $\varepsilon_a$
       eb                       $\varepsilon_b$
;

// Declaration of the parameters.
parameters SIGMAC               $\sigma_C$
	   XIH                  $\xi_h$
	   ETA                  $\eta$
	   BETA                 $\beta$
	   NU                   $\nu$
	   PSI                  $\psi$
	   EPSILON              $\epsilon$
	   RHOA                 $\rho_a$
	   RHOB                 $\rho_b$
	   GAMMAPI              $\gamma_{\pi}$
	   PHI                  $\varphi$
;


// Calibration.
SIGMAC = 1.5;
ETA = 2;
BETA = 0.997;
NU = 0.75;
PSI = -10;
EPSILON = 6;
PHI = EPSILON*(1+PSI)/(EPSILON*(1+PSI)-1);
RHOA = .98;
RHOB = .2;
GAMMAPI = 1.2;
XIH = 0; // This parameter will be updated in the steady state file.

// Update the value of the Calvo probability if PSI is not equal to -.1.
slope = 0.075074404761905;                      // from (EPSILON-1)/(EPSILON*(1-PSI)-1)*(1-NU)*(1-BETA*NU)/NU; with NU=.75 and PSI=-.1 (formula is
                                                // obtained by linearizing the Phillips curve).
gamma = slope*(EPSILON*(1-PSI)-1)/(EPSILON-1);
discr = ((1+gamma+BETA)/BETA)^2-4/BETA;
NU    = .5*((1+gamma+BETA)/BETA-sqrt(discr));




// Deterministic steady state levels for inflation, hours, risk premium and efficiency are defined
// in the steadystate file.

model;

    [type = 'Definition of the exogenous state variables']
    Efficiency - STEADY_STATE(Efficiency)*exp(a);

    [type = 'Definition of the exogenous state variables']
    RiskPremium - STEADY_STATE(RiskPremium)*exp(b);

    [type = 'Definition of the exogenous state variables']
    a - RHOA*a(-1) - ea ;

    [type = 'Definition of the exogenous state variables']
    b - RHOB*b(-1) - eb ;

    [type = 'Definition of the non predetermined variables']
    Lambda - 1*Consumption^(-SIGMAC);

    [type = 'Definition of the non predetermined variables']
    Hours^ETA*XIH + Lambda*RealWage;

    [type = 'Euler equations']
    BETA*RiskPremium*Exp1(1) - Lambda/NominalInterestRate;

    [type = 'Euler equations']
    Z1 - Output*RealWage/Efficiency*Theta^(-PHI) - BETA*NU*Exp2(1)/Lambda;

    [type = 'Euler equations']
    Z2 - Output*Theta^(-PHI) - BETA*NU*Exp3(1)/Lambda;

    [type = 'Euler equations']
    Z3 - Output - BETA*NU*Exp4(1)/Lambda;

    [type = 'Definition of the non predetermined variables']
    Z2/((1+PSI)*(1-PHI))*RelativePrice^(PHI/(1-PHI))+Z3*PSI/(1+PSI)+Z1*PHI/((1+PSI)*(PHI-1))*RelativePrice^(PHI/(1-PHI)-1);

    [type = 'Definition of the endogenous state variables']
    NU*Theta(-1)*(STEADY_STATE(Inflation)/Inflation)^(1/(1-PHI))+(1-NU)*RelativePrice^(1/(1-PHI)) - Theta;

    [type = 'Definition of the non predetermined variables']
    Theta^(1-PHI)-PSI-1 + PSI*RelativePrice*(1-NU) + STEADY_STATE(Inflation)/Inflation*NU*(1+PSI-Theta(-1)^(1-PHI));

    [type = 'Definition of the non predetermined variables']
    (Output*(PSI + Dist/Theta^PHI))/(PSI + 1) - Efficiency*Hours;

    [type = 'Definition of the non predetermined variables']
    Consumption - Output;

    [type = 'Taylor']
    NominalInterestRate-max(1.0,STEADY_STATE(NominalInterestRate)*(Inflation/STEADY_STATE(Inflation))^GAMMAPI);

    [type = 'Definition of the endogenous state variables']
    (Dist(-1)*NU)/(STEADY_STATE(Inflation)/Inflation)^(PHI/(PHI - 1)) - (NU - 1)/RelativePrice^(PHI/(PHI - 1)) - Dist;

    [type = 'Definition of the auxiliary forward variables']
    Exp1 - Lambda/Inflation;

    [type = 'Definition of the auxiliary forward variables']
    Exp2 - (Lambda*Z1)/(STEADY_STATE(Inflation)/Inflation)^(PHI/(PHI - 1));

    [type = 'Definition of the auxiliary forward variables']
    Exp3 - (Lambda*Z2)/(STEADY_STATE(Inflation)/Inflation)^(1/(PHI - 1));

    [type = 'Definition of the auxiliary forward variables']
    Exp4 - (STEADY_STATE(Inflation)*Lambda*Z3)/Inflation;

end;

shocks;
  var ea = .0002;
  var eb = .0001;
end;

install_steadystate_file();

steady;

// extended_path(periods=100);
