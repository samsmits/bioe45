metadata = read_mixed_csv('allMetadata.csv',',');
%% Call function to create bar chart for given categories
textColumns = [1 6 11 12 13 14 15 16 17 18 19 20 21 22 23 25 26 33 34 ...
    35 36 37 45 222 223 224 225 226 227 228 229 230 231 234 235 236 237 ...
    238 239 244 241 242 244 245 246 247 249 250 251 254 255 256 257 259 ...
    260 261 263 264 265 266 267 268 269 270 271 272 273 274 276 277 278 ...
    279 280 281 282 284 285 289 291 293 294 295 296 297 298 299 300 304 ...
    305 306 307 309 310 311 312 313 315 316 317 318 319 320 321 323 324];

categories = {'Pregnant'}; % exact entry names for making bar charts
% if all or a range of categories are desired, uncomment and modify below:
%columns = textColumns; % or can be specified, e.g. columns = 11:15;
%categories = metadata(1,columns);

visible = 'on';
save = 'off';
fullscreen = 'off'; % fullscreen didn't work on my computer
tickUp = 600; % upward pixels to move the xlabels
SummaryStatsOfText(metadata, categories, visible, save, fullscreen, tickUp)