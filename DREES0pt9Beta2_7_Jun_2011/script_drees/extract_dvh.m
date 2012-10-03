function [dx,vx,mohx,mocx,geud,meandose,maxdose,mindose,outcome]=extract_dvh(dBase, dvhName, arrayDxx, arrayVxx, arrayMOHxx, arrayMOCxx, arrayEUDxx)

%OHJ 07/26/2012, script-based DREES

dx = zeros(length(arrayDxx), length(dBase));
vx = zeros(length(arrayVxx), length(dBase));
mohx= zeros(length(arrayMOHxx), length(dBase));
mocx= zeros(length(arrayMOCxx), length(dBase));
geud= zeros(length(arrayEUDxx), length(dBase));
meandose=[];
maxdose=[];
mindose=[];

if(~isfield(dBase, dvhName))
    error(['specified DVH ' dvhName ' is not a field']);
else
    if(~isempty(arrayDxx)), 
        
        for i = 1:length(arrayDxx), 
            for j = 1:length(dBase), 
                dvh = dBase(j).(dvhName);
                dx(i,j) = calc_Dx(dvh(1, :), dvh(2, :), arrayDxx(i));
                
            end
            
        end
    end
    
    if(~isempty(arrayVxx)), 
        for i = 1:length(arrayVxx), 
            
            for j = 1:length(dBase), 
                dvh = dBase(j).(dvhName);
                vx(i,j) = calc_Vx(dvh(1, :), dvh(2, :), arrayVxx(i),1); % fractional
                %vxx_absolute(i,j) = calc_Vx(dvh(1, :), dvh(2, :), arrayVxx(i),0); % absolute
                
            end
           
        end
    end
    
     if(~isempty(arrayMOHxx)), 
        for i = 1:length(arrayMOHxx), 
           
            for j = 1:length(dBase), 
                dvh = dBase(j).(dvhName);
                mohx(i,j) = calc_MOHx(dvh(1, :), dvh(2, :), arrayMOHxx(i)); 
               
            end
           
        end
     end
     
     if(~isempty(arrayMOCxx)), 
        for i = 1:length(arrayMOCxx), 
            
            for j = 1:length(dBase), 
                dvh = dBase(j).(dvhName);
                mocx(i,j) = calc_MOCx(dvh(1, :), dvh(2, :), arrayMOCxx(i)); 
               
            end
           
        end
     end
    
     if(~isempty(arrayEUDxx)), 
        for i = 1:length(arrayEUDxx), 
            
            for j = 1:length(dBase), 
                dvh = dBase(j).(dvhName);
                geud(i,j) = calc_EUD(dvh(1, :), dvh(2, :), arrayEUDxx(i)); 
                
            end
           
        end
     end
     

    for j = 1:length(dBase)
        dvh = dBase(j).(dvhName);
        meandose(j) = calc_meanDose(dvh(1,:),dvh(2,:));
       
    end
    
 
    for j = 1:length(dBase)
        dvh = dBase(j).(dvhName);
        maxdose(j) = max(dvh(1,:));
      
    end
    
 
    for j = 1:length(dBase)
        dvh = dBase(j).(dvhName);
        mindose(j) = calc_minDose(dvh(1,:),dvh(2,:));
      
    end
    
    %outcome extraction
    for j = 1:length(dBase)
        outcome(j) = dBase(j).outcome;
               
    end
end

dx=dx';
vx=vx';
mohx=mohx';
mocx=mocx';
geud=geud';
meandose=meandose';
maxdose=maxdose';
mindose=mindose';
