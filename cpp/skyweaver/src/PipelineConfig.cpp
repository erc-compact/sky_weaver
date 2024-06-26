#include "skyweaver/PipelineConfig.hpp"

#include <boost/algorithm/string.hpp> 

#include <fstream>

namespace skyweaver
{

PipelineConfig::PipelineConfig()
    : _delay_file("delays.swd"), _input_files({}), _output_dir("./"),
      _statistics_file("./statistics.bin"), _coherent_dms({0.0f}),
      _cfreq(1284000000.0), _bw(13375000.0), _channel_frequencies_stale(true),
      _output_level(24.0f), _cb_power_scaling(0.0f), _cb_power_offset(0.0f),
      _ib_power_scaling(0.0f), _ib_power_offset(0.0f)
{
}

PipelineConfig::~PipelineConfig()
{
}

void PipelineConfig::delay_file(std::string const& fpath)
{
    _delay_file = fpath;
}

std::string const& PipelineConfig::delay_file() const
{
    return _delay_file;
}

void PipelineConfig::input_files(std::vector<std::string> const& files)
{
    _input_files = files;
}

std::vector<std::string> const& PipelineConfig::input_files() const
{
    return _input_files;
}

void PipelineConfig::read_input_file_list(std::string filename)
{
    std::string line;
    std::ifstream ifs(filename.c_str());
    if(!ifs.is_open()) {
        std::cerr << "Unable to open input file list: " << filename
                  << " (" << std::strerror(errno) << ")\n";
        throw std::runtime_error(std::strerror(errno));
    }
    _input_files.resize(0);
    while ( std::getline (ifs, line) )
    {
        boost::algorithm::trim(line);
        if (line.rfind("#", 0))
        {
            // Line is a comment
            continue;
        } else {
            _input_files.push_back(line);
        }
    }
    ifs.close();
}

void PipelineConfig::output_dir(std::string const& path)
{
    _output_dir = path;
}

std::string const& PipelineConfig::output_dir() const
{
    return _output_dir;
}

void PipelineConfig::statistics_file(std::string const& filename)
{
    _statistics_file = filename;
}

std::string const& PipelineConfig::statistics_file() const
{
    return _statistics_file;
}

double PipelineConfig::centre_frequency() const
{
    return _cfreq;
}

void PipelineConfig::centre_frequency(double cfreq)
{
    _cfreq                     = cfreq;
    _channel_frequencies_stale = true;
}

double PipelineConfig::bandwidth() const
{
    return _bw;
}

void PipelineConfig::bandwidth(double bw)
{
    _bw                        = bw;
    _channel_frequencies_stale = true;
}

std::vector<float> const& PipelineConfig::coherent_dms() const
{
    return _coherent_dms;
}

void PipelineConfig::coherent_dms(std::vector<float> const& coherent_dms)
{
    _coherent_dms = coherent_dms;
}

std::vector<double> const& PipelineConfig::channel_frequencies() const
{
    if(_channel_frequencies_stale) {
        calculate_channel_frequencies();
    }
    return _channel_frequencies;
}

void PipelineConfig::calculate_channel_frequencies() const
{
    /**
     * Need to revisit this implementation as it is not clear how the
     * frequencies are labeled for the data out of the F-engine. Either
     * way is a roughly correct place-holder.
     */
    double chbw    = bandwidth() / nchans();
    double fbottom = centre_frequency() - bandwidth() / 2.0;
    _channel_frequencies.clear();
    for(std::size_t chan_idx = 0; chan_idx < nchans(); ++chan_idx) {
        _channel_frequencies.push_back(fbottom + chbw / 2.0 +
                                       (chbw * chan_idx));
    }
    _channel_frequencies_stale = false;
}

void PipelineConfig::output_level(float level)
{
    _output_level = level;
}

float PipelineConfig::output_level() const
{
    return _output_level;
}

} // namespace skyweaver
