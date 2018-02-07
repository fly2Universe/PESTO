function [negLogPost_opt, par_opt, gradient_opt, hessian_opt, exitflag, n_objfun, n_iter] ...
    = performOptimizationBobyqa(parameters, negLogPost, par0, options)

    % Definition of index set of optimized parameters
    freePars = setdiff(1:parameters.number, options.fixedParameters);
    optionsBobyqa = options.localOptimizerOptions;
    
    % Set bounds
    lowerBounds = parameters.min;
    upperBounds = parameters.max;
    
    % run Bobyqa
    [par_opt, negLogPost_opt, exitflag, output] = bobyqa(...
        negLogPost,...
        par0,...
        lowerBounds(freePars),...
        upperBounds(freePars),...
        optionsBobyqa);
    
    % Assignment of results
    n_objfun(iMS)  = output.funcCount;
    n_iter(iMS)    = output.funcCount;
    par_opt(freePars) = par_opt;
    par_opt(options.fixedParameters) = options.fixedParameterValues;
    
    % Assignment of gradient and Hessian
    try
        [~, gradient_opt, hessian_opt] = negLogPost(par_opt);
        hessian_opt(freePars,freePars,iMS) = hessian_opt;
        hessian_opt(options.fixedParameters,options.fixedParameters,iMS) = nan;
        gradient_opt(freePars,iMS) = gradient_opt;
        gradient_opt(options.fixedParameters,iMS) = nan;
    catch
        warning('Could not compute Hessian and gradient at optimum after optimization.');
        if (options.objOutNumber == 3)
            warning('options.objOutNumber is set to 3, but your objective function can not provide 3 outputs. Please set objOutNumber accordingly!');
        end
    end

end