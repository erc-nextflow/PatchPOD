function out_cell = split_vector(input, num_slices)
	out = buffer(input, max(1,round(length(input) / num_slices)));
	out_cell = cell(size(out, 2), 1);
	for i = 1 : size(out, 2) - 1
		out_cell{i, 1} = out(:, i);
	end
	
	% Remove trailing zeros
	i_trail = find(out(:, end), 1, 'last');
	out_cell{end, 1} = out(1:i_trail, end);
end