function loadSubfolders()
% This function loads all sub folders but not always. Loading is only made
% when a certain files is not found. This is a quite stupid way to check if
% the subfolders is already added and will not work if you add a new folder

if (~exist('getCameraman.m','file') || ~exist('pnp.m','file')) %simply check if a certain functions exists...
    fprintf('Adding external dependencies to path... \n')
    addpath(genpath('../')) %external functions
end


% folderContents = dir();
% fprintf('Adding external dependencies to path...')
% for i = 3:length(folderContents)
%     name = folderContents(i).name;
%     nameIsUpdir = ~strcmp(name,'..');
%     nameIsDotDir = ~strcmp(name,'.');
%     isDir = folderContents(i).isdir;
%     if(isDir && (nameIsUpdir~=1) && (nameIsDotDir~=1))
%         
%         p = [pwd '\' name];
%         
%         if ispc
%           % Windows is not case-sensitive
%           onPath = ~isempty(strfind(lower(path),lower(p)));
%         else
%           onPath = ~isempty(strfind(path,p));
%         end
% 
%         
%         
%         if(~onPath)            
%             addpath(genpath(name)) %external functions
%             fprintf('\t%s\n',name)
%         end
%     
%     end
% end
% 
% fprintf('Done\n')

end